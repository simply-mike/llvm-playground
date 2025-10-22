#include "../../00-SDL/include/GUI-lib.h"

#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

Function* createSetBoundCondDefine(LLVMContext& context, Module& module, FunctionCallee& guiRandFunc) {
  IRBuilder<> builder(context);
  
  FunctionType *setBoundCondFuncType = FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
  Function *setBoundCondFunc = Function::Create(setBoundCondFuncType, Function::ExternalLinkage, "set_bound_cond", module);

  BasicBlock *BB1 = BasicBlock::Create(context, "", setBoundCondFunc);
  BasicBlock *BB2 = BasicBlock::Create(context, "", setBoundCondFunc);
  BasicBlock *BB3 = BasicBlock::Create(context, "", setBoundCondFunc);

  Value* arg0 = setBoundCondFunc->arg_begin();
  
  // 1:
  builder.SetInsertPoint(BB1);
  // br label %3
  builder.CreateBr(BB3);
  
  // 2:                                                ; preds = %3
  builder.SetInsertPoint(BB2);
  // ret void
  builder.CreateRetVoid();
  
  // 3:                                                ; preds = %1, %3
  builder.SetInsertPoint(BB3);
  // %4 = phi i64 [ 0, %1 ], [ %9, %3 ]
  PHINode *val4 = builder.CreatePHI(builder.getInt64Ty(), 2);
  // %5 = tail call i32 @gui_rand() #5
  CallInst* val5 = builder.CreateCall(guiRandFunc);
  // %6 = trunc i32 %5 to i8
  Value *val6 = builder.CreateTrunc(val5, builder.getInt8Ty());
  // %7 = and i8 %6, 1
  Value *val7 = builder.CreateAnd(val6, builder.getInt8(1));
  // %8 = getelementptr inbounds nuw i8, ptr %0, i64 %4
  Value* val8 = builder.CreateInBoundsGEP(builder.getInt8Ty(), arg0, val4);
  // store i8 %7, ptr %8, align 1, !tbaa !3
  builder.CreateStore(val7, val8);
  // %9 = add nuw nsw i64 %4, 1
  Value *val9 = builder.CreateAdd(val4, builder.getInt64(1), "", true, true);
  // %10 = icmp eq i64 %9, 512
  Value *val10 = builder.CreateICmpEQ(val9, builder.getInt64(512));
  // br i1 %10, label %2, label %3, !llvm.loop !7
  builder.CreateCondBr(val10, BB2, BB3);
  
  // Link PHI nodes
  val4->addIncoming(builder.getInt64(0), BB1);
  val4->addIncoming(val9, BB3);
  
  return setBoundCondFunc;
}

Function* createApplyRuleDefine(LLVMContext& context, Module& module) {
  IRBuilder<> builder(context);
  
  FunctionType *applyRuleFuncType = FunctionType::get(builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy()}, false);
  Function *applyRuleFunc = Function::Create(applyRuleFuncType, Function::ExternalLinkage, "apply_rule", module);

  BasicBlock *BB2 = BasicBlock::Create(context, "", applyRuleFunc);
  BasicBlock *BB3 = BasicBlock::Create(context, "", applyRuleFunc);
  BasicBlock *BB4 = BasicBlock::Create(context, "", applyRuleFunc);

  Value* arg0 = applyRuleFunc->arg_begin();
  Value* arg1 = std::next(applyRuleFunc->arg_begin());
  
  // 2:
  builder.SetInsertPoint(BB2);
  // br label %4
  builder.CreateBr(BB4);
  
  // 3:                                                ; preds = %4
  builder.SetInsertPoint(BB3);
  // ret void
  builder.CreateRetVoid();
  
  // 4:                                                ; preds = %2, %4
  builder.SetInsertPoint(BB4);
  // %5 = phi i64 [ 0, %2 ], [ %17, %4 ]
  PHINode *val5 = builder.CreatePHI(builder.getInt64Ty(), 2);
  // %6 = add nuw i64 %5, 511
  Value *val6 = builder.CreateAdd(val5, builder.getInt64(511), "", true, false);
  // %7 = and i64 %6, 511
  Value *val7 = builder.CreateAnd(val6, builder.getInt64(511));
  // %8 = getelementptr inbounds nuw i8, ptr %0, i64 %7
  Value* val8 = builder.CreateInBoundsGEP(builder.getInt8Ty(), arg0, val7);
  // %9 = load i8, ptr %8, align 1, !tbaa !3, !range !9, !noundef !10
  Value* val9 = builder.CreateLoad(builder.getInt8Ty(), val8);
  // %10 = trunc nuw i8 %9 to i1
  Value *val10 = builder.CreateTrunc(val9, builder.getInt1Ty());
  // %11 = select i1 %10, i32 4, i32 0
  Value* val11 = builder.CreateSelect(val10, builder.getInt32(4), builder.getInt32(0));
  // %12 = getelementptr inbounds nuw i8, ptr %0, i64 %5
  Value* val12 = builder.CreateInBoundsGEP(builder.getInt8Ty(), arg0, val5);
  // %13 = load i8, ptr %12, align 1, !tbaa !3, !range !9, !noundef !10
  Value* val13 = builder.CreateLoad(builder.getInt8Ty(), val12);
  // %14 = trunc nuw i8 %13 to i1
  Value *val14 = builder.CreateTrunc(val13, builder.getInt1Ty());
  // %15 = or disjoint i32 %11, 2
  Value* val15 = builder.CreateOr(val11, builder.getInt32(2));
  // %16 = select i1 %14, i32 %15, i32 %11
  Value* val16 = builder.CreateSelect(val14, val15, val11);
  // %17 = add nuw nsw i64 %5, 1
  Value *val17 = builder.CreateAdd(val5, builder.getInt64(1), "", true, true);
  // %18 = and i64 %17, 511
  Value *val18 = builder.CreateAnd(val17, builder.getInt64(511));
  // %19 = getelementptr inbounds nuw i8, ptr %0, i64 %18
  Value* val19 = builder.CreateInBoundsGEP(builder.getInt8Ty(), arg0, val18);
  // %20 = load i8, ptr %19, align 1, !tbaa !3, !range !9, !noundef !10
  Value* val20 = builder.CreateLoad(builder.getInt8Ty(), val19);
  // %21 = zext nneg i8 %20 to i32
  Value* val21 = builder.CreateZExt(val20, builder.getInt32Ty());
  // %22 = or disjoint i32 %16, %21
  Value* val22 = builder.CreateOr(val16, val21);
  // %23 = lshr i32 110, %22
  Value* val23 = builder.CreateLShr(builder.getInt32(110), val22);
  // %24 = trunc nuw nsw i32 %23 to i8
  Value* val24 = builder.CreateTrunc(val23, builder.getInt8Ty());
  // %25 = and i8 %24, 1
  Value *val25 = builder.CreateAnd(val24, builder.getInt8(1));
  // %26 = getelementptr inbounds nuw i8, ptr %1, i64 %5
  Value* val26 = builder.CreateInBoundsGEP(builder.getInt8Ty(), arg1, val5);
  // store i8 %25, ptr %26, align 1, !tbaa !3
  builder.CreateStore(val25, val26);
  // %27 = icmp eq i64 %17, 512
  Value *val27 = builder.CreateICmpEQ(val17, builder.getInt64(512));
  // br i1 %27, label %3, label %4, !llvm.loop !11
  builder.CreateCondBr(val27, BB3, BB4);
  
  // Link PHI nodes
  val5->addIncoming(builder.getInt64(0), BB2);
  val5->addIncoming(val17, BB4);
  
  return applyRuleFunc;
}

Function* createAppDefine(LLVMContext& context, Module& module,
                          FunctionCallee& guiRandFunc, FunctionCallee& guiSetPixelFunc,
                          FunctionCallee& guiFlushFunc, FunctionCallee& guiQuitEventFunc) {
  IRBuilder<> builder(context);

  Function *memsetFunc = Intrinsic::getDeclaration(&module, Intrinsic::memset, 
                                                    { builder.getPtrTy(), builder.getInt64Ty() });

  FunctionType *appFuncType = FunctionType::get(builder.getVoidTy(), false);
  Function *appFunc = Function::Create(appFuncType, Function::ExternalLinkage, "app", module);

  BasicBlock *BB0 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB2 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB10 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB13 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB22 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB44 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB48 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB51 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB54 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB60 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB61 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB62 = BasicBlock::Create(context, "", appFunc);
  BasicBlock *BB65 = BasicBlock::Create(context, "", appFunc);

  // 0:
  builder.SetInsertPoint(BB0);
  // %1 = alloca [512 x [512 x i8]], align 16
  ArrayType *inner = ArrayType::get(builder.getInt8Ty(), 512);
  ArrayType *outer = ArrayType::get(inner, 512);
  AllocaInst* val1 = builder.CreateAlloca(outer);
  val1->setAlignment(Align(16));
  // call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(262144) %1, i8 0, i64 262144, i1 false)
  builder.CreateCall(memsetFunc, {val1, builder.getInt8(0), builder.getInt64(262144), builder.getInt1(false)});
  // br label %2
  builder.CreateBr(BB2);
  
  // 2:                                                ; preds = %2, %0
  builder.SetInsertPoint(BB2);
  // %3 = phi i64 [ 0, %0 ], [ %8, %2 ]
  PHINode *val3 = builder.CreatePHI(builder.getInt64Ty(), 2);
  // %4 = tail call i32 @gui_rand() #5
  CallInst* val4 = builder.CreateCall(guiRandFunc);
  // %5 = trunc i32 %4 to i8
  Value *val5 = builder.CreateTrunc(val4, builder.getInt8Ty());
  // %6 = and i8 %5, 1
  Value *val6 = builder.CreateAnd(val5, builder.getInt8(1));
  // %7 = getelementptr inbounds nuw i8, ptr %1, i64 %3
  Value* val7 = builder.CreateInBoundsGEP(builder.getInt8Ty(), val1, val3);
  // store i8 %6, ptr %7, align 1, !tbaa !3
  builder.CreateStore(val6, val7);
  // %8 = add nuw nsw i64 %3, 1
  Value *val8 = builder.CreateAdd(val3, builder.getInt64(1), "", true, true);
  // %9 = icmp eq i64 %8, 512
  Value *val9 = builder.CreateICmpEQ(val8, builder.getInt64(512));
  // br i1 %9, label %10, label %2, !llvm.loop !7
  builder.CreateCondBr(val9, BB10, BB2);

  // 10:                                               ; preds = %2
  builder.SetInsertPoint(BB10);
  // %11 = tail call i32 @gui_quit_event() #5
  CallInst* val11 = builder.CreateCall(guiQuitEventFunc);
  // %12 = icmp eq i32 %11, 0
  Value *val12 = builder.CreateICmpEQ(val11, builder.getInt32(0));
  // br i1 %12, label %13, label %65
  builder.CreateCondBr(val12, BB13, BB65);

  // 13:                                               ; preds = %10, %48
  builder.SetInsertPoint(BB13);
  // %14 = phi i32 [ %18, %48 ], [ 0, %10 ]
  PHINode *val14 = builder.CreatePHI(builder.getInt32Ty(), 2);
  // %15 = and i32 %14, 511
  Value *val15 = builder.CreateAnd(val14, builder.getInt32(511));
  // %16 = zext nneg i32 %15 to i64
  Value* val16 = builder.CreateZExt(val15, builder.getInt64Ty());
  // %17 = getelementptr inbounds nuw [512 x [512 x i8]], ptr %1, i64 0, i64 %16
  Value* val17 = builder.CreateInBoundsGEP(outer, val1, {builder.getInt64(0), val16});
  // %18 = add nuw nsw i32 %14, 1
  Value *val18 = builder.CreateAdd(val14, builder.getInt32(1), "", true, true);
  // %19 = and i32 %18, 511
  Value *val19 = builder.CreateAnd(val18, builder.getInt32(511));
  // %20 = zext nneg i32 %19 to i64
  Value* val20 = builder.CreateZExt(val19, builder.getInt64Ty());
  // %21 = getelementptr inbounds nuw [512 x [512 x i8]], ptr %1, i64 0, i64 %20
  Value* val21 = builder.CreateInBoundsGEP(outer, val1, {builder.getInt64(0), val20});
  // br label %22
  builder.CreateBr(BB22);
  
  // 22:                                               ; preds = %13, %22
  builder.SetInsertPoint(BB22);
  // %23 = phi i64 [ 0, %13 ], [ %35, %22 ]
  PHINode *val23 = builder.CreatePHI(builder.getInt64Ty(), 2);
  // %24 = add nuw nsw i64 %23, 511
  Value *val24 = builder.CreateAdd(val23, builder.getInt64(511), "", true, true);
  // %25 = and i64 %24, 511
  Value *val25 = builder.CreateAnd(val24, builder.getInt64(511));
  // %26 = getelementptr inbounds nuw i8, ptr %17, i64 %25
  Value* val26 = builder.CreateInBoundsGEP(builder.getInt8Ty(), val17, val25);
  // %27 = load i8, ptr %26, align 1, !tbaa !3, !range !9, !noundef !10
  Value* val27 = builder.CreateLoad(builder.getInt8Ty(), val26);
  // %28 = trunc nuw i8 %27 to i1
  Value *val28 = builder.CreateTrunc(val27, builder.getInt1Ty());
  // %29 = select i1 %28, i8 4, i8 0
  Value* val29 = builder.CreateSelect(val28, builder.getInt8(4), builder.getInt8(0));
  // %30 = getelementptr inbounds nuw i8, ptr %17, i64 %23
  Value* val30 = builder.CreateInBoundsGEP(builder.getInt8Ty(), val17, val23);
  // %31 = load i8, ptr %30, align 1, !tbaa !3, !range !9, !noundef !10
  Value* val31 = builder.CreateLoad(builder.getInt8Ty(), val30);
  // %32 = trunc nuw i8 %31 to i1
  Value *val32 = builder.CreateTrunc(val31, builder.getInt1Ty());
  // %33 = or disjoint i8 %29, 2
  Value* val33 = builder.CreateOr(val29, builder.getInt8(2));
  // %34 = select i1 %32, i8 %33, i8 %29
  Value* val34 = builder.CreateSelect(val32, val33, val29);
  // %35 = add nuw nsw i64 %23, 1
  Value *val35 = builder.CreateAdd(val23, builder.getInt64(1), "", true, true);
  // %36 = and i64 %35, 511
  Value *val36 = builder.CreateAnd(val35, builder.getInt64(511));
  // %37 = getelementptr inbounds nuw i8, ptr %17, i64 %36
  Value* val37 = builder.CreateInBoundsGEP(builder.getInt8Ty(), val17, val36);
  // %38 = load i8, ptr %37, align 1, !tbaa !3, !range !9, !noundef !10
  Value* val38 = builder.CreateLoad(builder.getInt8Ty(), val37);
  // %39 = or disjoint i8 %34, %38
  Value* val39 = builder.CreateOr(val34, val38);
  // %40 = lshr i8 110, %39
  Value* val40 = builder.CreateLShr(builder.getInt8(110), val39);
  // %41 = and i8 %40, 1
  Value *val41 = builder.CreateAnd(val40, builder.getInt8(1));
  // %42 = getelementptr inbounds nuw i8, ptr %21, i64 %23
  Value* val42 = builder.CreateInBoundsGEP(builder.getInt8Ty(), val21, val23);
  // store i8 %41, ptr %42, align 1, !tbaa !3
  builder.CreateStore(val41, val42);
  // %43 = icmp eq i64 %35, 512
  Value *val43 = builder.CreateICmpEQ(val35, builder.getInt64(512));
  // br i1 %43, label %44, label %22, !llvm.loop !13
  builder.CreateCondBr(val43, BB44, BB22);

  // 44:                                               ; preds = %22, %51
  builder.SetInsertPoint(BB44);
  // %45 = phi i64 [ %52, %51 ], [ 0, %22 ]
  PHINode *val45 = builder.CreatePHI(builder.getInt64Ty(), 2);
  // %46 = trunc nuw nsw i64 %45 to i32
  Value *val46 = builder.CreateTrunc(val45, builder.getInt32Ty());
  // %47 = trunc nuw nsw i64 %45 to i32
  Value *val47 = builder.CreateTrunc(val45, builder.getInt32Ty());
  // br label %54
  builder.CreateBr(BB54);

  // 48:                                               ; preds = %51
  builder.SetInsertPoint(BB48);
  // tail call void @gui_flush() #5
  builder.CreateCall(guiFlushFunc);
  // %49 = tail call i32 @gui_quit_event() #5
  CallInst* val49 = builder.CreateCall(guiQuitEventFunc);
  // %50 = icmp eq i32 %49, 0
  Value *val50 = builder.CreateICmpEQ(val49, builder.getInt32(0));
  // br i1 %50, label %13, label %65
  builder.CreateCondBr(val50, BB13, BB65);

  // 51:                                               ; preds = %62
  builder.SetInsertPoint(BB51);
  // %52 = add nuw nsw i64 %45, 1
  Value *val52 = builder.CreateAdd(val45, builder.getInt64(1), "", true, true);
  // %53 = icmp eq i64 %52, 512
  Value *val53 = builder.CreateICmpEQ(val52, builder.getInt64(512));
  // br i1 %53, label %48, label %44, !llvm.loop !14
  builder.CreateCondBr(val53, BB48, BB44);

  // 54:                                               ; preds = %44, %62
  builder.SetInsertPoint(BB54);
  // %55 = phi i64 [ 0, %44 ], [ %63, %62 ]
  PHINode *val55 = builder.CreatePHI(builder.getInt64Ty(), 2);
  // %56 = getelementptr inbounds nuw [512 x [512 x i8]], ptr %1, i64 0, i64 %45, i64 %55
  Value* val56 = builder.CreateInBoundsGEP(outer, val1, {builder.getInt64(0), val45, val55});
  // %57 = load i8, ptr %56, align 1, !tbaa !3, !range !9, !noundef !10
  Value* val57 = builder.CreateLoad(builder.getInt8Ty(), val56);
  // %58 = trunc nuw i8 %57 to i1
  Value *val58 = builder.CreateTrunc(val57, builder.getInt1Ty());
  // %59 = trunc nuw nsw i64 %55 to i32
  Value *val59 = builder.CreateTrunc(val55, builder.getInt32Ty());
  // br i1 %58, label %60, label %61
  builder.CreateCondBr(val58, BB60, BB61);

  // 60:                                               ; preds = %54
  builder.SetInsertPoint(BB60);
  // tail call void @gui_set_pixel(i32 noundef %59, i32 noundef %47, i32 noundef 255) #5
  builder.CreateCall(guiSetPixelFunc, {val59, val47, builder.getInt32(255)});
  // br label %62
  builder.CreateBr(BB62);

  // 61:                                               ; preds = %54
  builder.SetInsertPoint(BB61);
  // tail call void @gui_set_pixel(i32 noundef %59, i32 noundef %46, i32 noundef -1) #5
  builder.CreateCall(guiSetPixelFunc, {val59, val46, builder.getInt32(-1)});
  // br label %62
  builder.CreateBr(BB62);

  // 62:                                               ; preds = %60, %61
  builder.SetInsertPoint(BB62);
  // %63 = add nuw nsw i64 %55, 1
  Value *val63 = builder.CreateAdd(val55, builder.getInt64(1), "", true, true);
  // %64 = icmp eq i64 %63, 512
  Value *val64 = builder.CreateICmpEQ(val63, builder.getInt64(512));
  // br i1 %64, label %51, label %54, !llvm.loop !15
  builder.CreateCondBr(val64, BB51, BB54);

  // 65:                                               ; preds = %48, %10
  builder.SetInsertPoint(BB65);
  // ret void
  builder.CreateRetVoid();
  
  // Link PHI nodes
  val3->addIncoming(builder.getInt64(0), BB0);
  val3->addIncoming(val8, BB2);
  
  val14->addIncoming(val18, BB48);
  val14->addIncoming(builder.getInt32(0), BB10);
  
  val23->addIncoming(builder.getInt64(0), BB13);
  val23->addIncoming(val35, BB22);
  
  val45->addIncoming(val52, BB51);
  val45->addIncoming(builder.getInt64(0), BB22);
  
  val55->addIncoming(builder.getInt64(0), BB44);
  val55->addIncoming(val63, BB62);
  
  return appFunc;
}

int main() {
  LLVMContext context;
  Module *mod = new Module("app.c", context);
  IRBuilder<> builder(context);

  // declare dso_local i32 @gui_rand() local_unnamed_addr #2
  FunctionType *guiRandType = FunctionType::get(builder.getInt32Ty(), false);
  FunctionCallee guiRandFunc = mod->getOrInsertFunction("gui_rand", guiRandType);

  // declare dso_local void @gui_set_pixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2
  ArrayRef<Type *> guiSetPixelParamTypes = {Type::getInt32Ty(context),
                                            Type::getInt32Ty(context),
                                            Type::getInt32Ty(context)};
  FunctionType *guiSetPixelType = FunctionType::get(builder.getVoidTy(), guiSetPixelParamTypes, false);
  FunctionCallee guiSetPixelFunc = mod->getOrInsertFunction("gui_set_pixel", guiSetPixelType);

  // declare dso_local void @gui_flush() local_unnamed_addr #2
  FunctionType *guiFlushType = FunctionType::get(builder.getVoidTy(), false);
  FunctionCallee guiFlushFunc = mod->getOrInsertFunction("gui_flush", guiFlushType);

  // declare dso_local i32 @gui_quit_event() local_unnamed_addr #2
  FunctionType *guiQuitEventType = FunctionType::get(builder.getInt32Ty(), false);
  FunctionCallee guiQuitEventFunc = mod->getOrInsertFunction("gui_quit_event", guiQuitEventType);

  Function* setBoundCondFunc = createSetBoundCondDefine(context, *mod, guiRandFunc);
  Function* applyRuleFunc = createApplyRuleDefine(context, *mod);
  Function* appFunc = createAppDefine(context, *mod, guiRandFunc, guiSetPixelFunc, guiFlushFunc, guiQuitEventFunc);

  // Dump LLVM IR
  mod->print(outs(), nullptr);

  // LLVM IR Interpreter
  outs() << "[EE] Run\n";
  InitializeNativeTarget();
  InitializeNativeTargetAsmPrinter();

  ExecutionEngine *ee = EngineBuilder(std::unique_ptr<Module>(mod)).create();

  ee->InstallLazyFunctionCreator([&](const std::string &fnName) -> void * {
    if (fnName == "gui_rand") {
      return reinterpret_cast<void *>(gui_rand);
    }
    if (fnName == "gui_set_pixel") {
      return reinterpret_cast<void *>(gui_set_pixel);
    }
    if (fnName == "gui_flush") {
      return reinterpret_cast<void *>(gui_flush);
    }
    if (fnName == "gui_quit_event") {
      return reinterpret_cast<void *>(gui_quit_event);
    }
    return nullptr;
  });
  ee->finalizeObject();
  gui_init();
  ArrayRef<GenericValue> noargs;
  GenericValue v = ee->runFunction(appFunc, noargs);
  outs() << "[EE] Result: " << v.IntVal << "\n";
  gui_exit();
  return EXIT_SUCCESS;
}