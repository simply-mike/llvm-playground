#!/usr/bin/env python3
"""
Analyzes the dynamic LLVM IR instruction trace received from the instrumented application.

Collects statistics on patterns 1-5 in length and stores the top N most frequent ones in the form of bar charts.
"""

import argparse
import subprocess
import sys
from pathlib import Path
from typing import List, Dict, Tuple

try:
    import matplotlib.pyplot as plt
except ImportError:
    print("Error: matplotlib is required. Install it with: pip install matplotlib")
    sys.exit(1)


PatternStats = Dict[str, int]
TotalStats = Dict[int, PatternStats]
CLIArgs = argparse.Namespace


def parse_options() -> CLIArgs:
    DEFAULT_BARS = 10
    DEFAULT_DURATION = 3.0
    DEFAULT_IMAGES_DIR = "./instruction_patterns"

    parser = argparse.ArgumentParser(
        description="Analysis of frequently occurring LLVM IR instruction patterns (length 1-5)."
    )
    parser.add_argument(
        "executable",
        help="The path to the instrumented executable file that outputs opcodes"
    )
    parser.add_argument(
        "--duration",
        type=float,
        default=DEFAULT_DURATION,
        help=f"Duration of the launch in seconds (by default: {DEFAULT_DURATION})"
    )
    parser.add_argument(
        "--top",
        type=int,
        default=DEFAULT_BARS,
        help=f"Number of top patterns to display (by default: {DEFAULT_BARS})"
    )
    parser.add_argument(
        "--output-dir",
        default=DEFAULT_IMAGES_DIR,
        help=f"Directory for saving graphs (by default: {DEFAULT_IMAGES_DIR})"
    )
    parser.add_argument(
        "--save-trace",
        action="store_true",
        help="Save the raw trace in trace.log"
    )

    args = parser.parse_args()

    exe_path = Path(args.executable).resolve()
    if not exe_path.is_file():
        raise FileNotFoundError(f"The executable file is not found: {exe_path}")

    Path(args.output_dir).mkdir(parents=True, exist_ok=True)
    return args


def run_instrumented_app(args: CLIArgs) -> List[str]:
    """Launch the application with a timeout and returns a list of opcodes."""
    cmd = ["timeout", "--preserve-status", f"{args.duration}s", str(args.executable)]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=False)
        lines = result.stdout.strip().splitlines()
        if args.save_trace:
            with open("trace.log", "w") as f:
                f.write("\n".join(lines) + "\n")
            print(f"The raw trace is saved in trace.log ({len(lines)} instructions)")
        return lines
    except FileNotFoundError:
        print("Error: The 'timeout' command was not found. Make sure coreutils are installed.")
        sys.exit(1)


def collect_statistics(instructions: List[str], max_len: int = 5) -> TotalStats:
    """Collect frequencies of patterns with a length of 1..max_len."""
    if not instructions:
        print("Warning: the trace is empty — the app may have terminated too quickly.")
        return {n: {} for n in range(1, max_len + 1)}

    stats: TotalStats = {}
    for n in range(1, max_len + 1):
        pattern_counts: PatternStats = {}
        for i in range(len(instructions) - n + 1):
            pattern = " → ".join(instructions[i:i + n])
            pattern_counts[pattern] = pattern_counts.get(pattern, 0) + 1
        stats[n] = pattern_counts
    return stats


def plot_top_patterns(stats: TotalStats, args: CLIArgs) -> None:
    """Save bar-graphs top-patterns in output_dir."""
    for length, patterns in stats.items():
        if not patterns:
            print(f"There are no {length} patterns, skipped.")
            continue

        sorted_patterns = sorted(patterns.items(), key=lambda x: x[1], reverse=True)
        top_patterns = dict(sorted_patterns[:args.top])

        plt.figure(figsize=(14, 8), dpi=120)
        plt.barh(list(top_patterns.keys()), list(top_patterns.values()))
        plt.gca().invert_yaxis()
        plt.title(f"Top-{len(top_patterns)} length {length} patterns", fontsize=14)
        plt.xlabel("Frequency", fontsize=12)
        plt.tight_layout()

        output_path = Path(args.output_dir) / f"patterns_len_{length}.png"
        plt.savefig(output_path, bbox_inches="tight")
        plt.close()
        print(f"Graph is saved in: {output_path}")


def main() -> None:
    args = parse_options()
    instructions = run_instrumented_app(args)
    stats = collect_statistics(instructions, max_len=5)
    plot_top_patterns(stats, args)
    print("\n Analysis is completed. Graphs are saved in:", args.output_dir)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nInterrupted by user.")
        sys.exit(1)
    except Exception as e:
        print(f"\n Error: {e}", file=sys.stderr)
        sys.exit(1)