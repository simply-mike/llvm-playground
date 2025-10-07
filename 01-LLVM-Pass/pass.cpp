#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Type.h"
#include "llvm/Passes/OptimizationLevel.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

using namespace llvm;

namespace {

StringRef LoggerName{"printInstr"};

FunctionType *getLoggerType(LLVMContext &Ctx) {
  Type *RetType = Type::getVoidTy(Ctx);
  PointerType *ArgType = PointerType::get(Type::getInt8Ty(Ctx), 0);
  return FunctionType::get(RetType, ArrayRef<Type *>{ArgType}, false);
}

struct InstrTracer final : public PassInfoMixin<InstrTracer> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &FAM) {
    LLVMContext &Ctx = M.getContext();
    FunctionType *LoggerType = getLoggerType(Ctx);
    FunctionCallee FCallee = M.getOrInsertFunction(LoggerName, LoggerType);

    auto NotLogger = [](const Function &F) {
      return F.getName() != LoggerName;
    };

    auto NotPHI = [](const Instruction &I) {
      return !isa<PHINode>(&I);
    };

    for (auto &F : make_filter_range(M, NotLogger)) {
      for (auto &BB : F) {
        for (auto &I : make_filter_range(BB, NotPHI)) {
          IRBuilder<> Builder(&I);
          Value *Str = Builder.CreateGlobalString(I.getOpcodeName(), "instr_name");
          Builder.CreateCall(FCallee, Str);
        }
      }
    }

    return PreservedAnalyses::none();
  }

  static bool isRequired() { return true; }
};

} // namespace

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return {
      LLVM_PLUGIN_API_VERSION,
      "Instruction tracer",
      "0.0.1",
      [](PassBuilder &PB) {
        PB.registerOptimizerLastEPCallback(
            [](ModulePassManager &MPM, OptimizationLevel Level,
               ThinOrFullLTOPhase Phase) -> bool {
              MPM.addPass(InstrTracer{});
              return true;
            });
      }};
}