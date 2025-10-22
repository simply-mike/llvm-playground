#!/usr/bin/env python3

import argparse
import json
import sys
from pathlib import Path
from collections import defaultdict

try:
    import matplotlib.pyplot as plt
except ImportError:
    print("Error: matplotlib is required. Install it with: pip install matplotlib")
    sys.exit(1)


def parse_options() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Analyze LLVM IR instruction trace from runtime.json."
    )
    parser.add_argument(
        "--input",
        type=str,
        default="../build/runtime.json",
        help="Path to runtime.json (default: ../build/runtime.json)"
    )
    parser.add_argument(
        "--top",
        type=int,
        default=10,
        help="Number of top patterns to display per length (default: 10)"
    )
    parser.add_argument(
        "--output-dir",
        default="./instruction_patterns",
        help="Directory for saving graphs (default: ./instruction_patterns)"
    )
    #parser.add_argument(
    #    "--save-trace",
    #    action="store_true",
    #    help="Save cleaned trace to trace.log"
    #)
    return parser.parse_args()


def load_trace(file_path: str) -> list[str]:
    with open(file_path, 'r') as f:
        content = f.read().strip()

    # Fix invalid JSON: remove trailing comma and empty string
    if content.endswith(',\n"" ]') or content.endswith(', "" ]'):
        # Find last comma before closing bracket and truncate
        last_comma = content.rfind(',', 0, content.rfind(']'))
        if last_comma != -1:
            content = content[:last_comma] + '\n]'

    try:
        data = json.loads(content)
    except json.JSONDecodeError:
        # Fallback: extract quoted strings manually
        import re
        strings = re.findall(r'"([^"]*)"', content)
        data = [s for s in strings if s]

    return [instr for instr in data if instr and isinstance(instr, str)]


def collect_statistics(instructions: list[str], max_len: int = 5) -> dict[int, dict[str, int]]:
    stats = {}
    for n in range(1, max_len + 1):
        counts = defaultdict(int)
        for i in range(len(instructions) - n + 1):
            pattern = " → ".join(instructions[i:i + n])
            counts[pattern] += 1
        stats[n] = dict(counts)
    return stats


def plot_top_patterns(stats: dict[int, dict[str, int]], args: argparse.Namespace) -> None:
    for length, patterns in stats.items():
        if not patterns:
            print(f"No patterns of length {length}, skipped.")
            continue

        top = dict(sorted(patterns.items(), key=lambda x: x[1], reverse=True)[:args.top])

        plt.figure(figsize=(14, 8))
        plt.barh(list(top.keys()), list(top.values()))
        plt.gca().invert_yaxis()
        plt.title(f"Top-{len(top)} patterns of length {length}")
        plt.xlabel("Frequency")
        plt.tight_layout()

        out_path = Path(args.output_dir) / f"patterns_len_{length}.png"
        plt.savefig(out_path, bbox_inches="tight")
        plt.close()
        print(f"Saved: {out_path}")


def main() -> None:
    args = parse_options()
    trace_path = Path(args.input).resolve()
    if not trace_path.is_file():
        sys.exit(f"Error: trace file not found: {trace_path}")

    instructions = load_trace(str(trace_path))

    #if args.save_trace:
    #    with open("trace.log", "w") as f:
    #        f.write("\n".join(instructions) + "\n")
    #    print(f"Saved cleaned trace to trace.log ({len(instructions)} instructions)")

    stats = collect_statistics(instructions)
    plot_top_patterns(stats, args)
    print(f"\nAnalysis complete. Results in: {args.output_dir}")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nInterrupted")
        sys.exit(1)
    except Exception as e:
        print(f"\nError: {e}", file=sys.stderr)
        sys.exit(1)