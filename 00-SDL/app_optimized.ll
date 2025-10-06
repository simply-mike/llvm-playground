; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-redhat-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define dso_local i32 @countNeighbors(ptr nocapture noundef readonly %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  br label %4

4:                                                ; preds = %3, %11
  %5 = phi i32 [ 0, %3 ], [ %31, %11 ]
  %6 = phi i32 [ -1, %3 ], [ %12, %11 ]
  %7 = add nsw i32 %6, %2
  %8 = icmp ult i32 %7, 75
  %9 = zext nneg i32 %7 to i64
  br label %14

10:                                               ; preds = %11
  ret i32 %31

11:                                               ; preds = %30
  %12 = add nsw i32 %6, 1
  %13 = icmp eq i32 %12, 2
  br i1 %13, label %10, label %4, !llvm.loop !3

14:                                               ; preds = %4, %30
  %15 = phi i32 [ %5, %4 ], [ %31, %30 ]
  %16 = phi i32 [ -1, %4 ], [ %32, %30 ]
  %17 = or i32 %16, %6
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %30, label %19

19:                                               ; preds = %14
  %20 = add nsw i32 %16, %1
  %21 = icmp ult i32 %20, 100
  %22 = select i1 %21, i1 %8, i1 false
  br i1 %22, label %23, label %30

23:                                               ; preds = %19
  %24 = zext nneg i32 %20 to i64
  %25 = getelementptr inbounds nuw [100 x i32], ptr %0, i64 %9, i64 %24
  %26 = load i32, ptr %25, align 4, !tbaa !6
  %27 = icmp eq i32 %26, 1
  %28 = zext i1 %27 to i32
  %29 = add nsw i32 %15, %28
  br label %30

30:                                               ; preds = %23, %19, %14
  %31 = phi i32 [ %15, %14 ], [ %15, %19 ], [ %29, %23 ]
  %32 = add nsw i32 %16, 1
  %33 = icmp eq i32 %32, 2
  br i1 %33, label %11, label %14, !llvm.loop !10
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: noreturn nounwind uwtable
define dso_local void @app() local_unnamed_addr #2 {
  %1 = alloca [75 x [100 x i32]], align 16
  %2 = alloca [75 x [100 x i32]], align 16
  call void @llvm.lifetime.start.p0(i64 30000, ptr nonnull %1) #5
  call void @llvm.lifetime.start.p0(i64 30000, ptr nonnull %2) #5
  br label %3

3:                                                ; preds = %0, %5
  %4 = phi i64 [ 0, %0 ], [ %6, %5 ]
  br label %8

5:                                                ; preds = %8
  %6 = add nuw nsw i64 %4, 1
  %7 = icmp eq i64 %6, 75
  br i1 %7, label %15, label %3, !llvm.loop !11

8:                                                ; preds = %3, %8
  %9 = phi i64 [ 0, %3 ], [ %13, %8 ]
  %10 = tail call i32 @simRand() #5
  %11 = srem i32 %10, 2
  %12 = getelementptr inbounds nuw [75 x [100 x i32]], ptr %1, i64 0, i64 %4, i64 %9
  store i32 %11, ptr %12, align 4, !tbaa !6
  %13 = add nuw nsw i64 %9, 1
  %14 = icmp eq i64 %13, 100
  br i1 %14, label %5, label %8, !llvm.loop !12

15:                                               ; preds = %5, %23
  %16 = phi i64 [ %24, %23 ], [ 0, %5 ]
  %17 = trunc i64 %16 to i32
  %18 = shl i32 %17, 3
  br label %25

19:                                               ; preds = %20
  tail call void (...) @simFlush() #5
  tail call void @simDelay(i32 noundef 100) #5
  br label %47

20:                                               ; preds = %36
  %21 = add nuw nsw i64 %16, 1
  %22 = icmp eq i64 %21, 75
  br i1 %22, label %19, label %23

23:                                               ; preds = %20, %56
  %24 = phi i64 [ %21, %20 ], [ 0, %56 ]
  br label %15, !llvm.loop !13

25:                                               ; preds = %15, %36
  %26 = phi i64 [ 0, %15 ], [ %37, %36 ]
  %27 = getelementptr inbounds nuw [75 x [100 x i32]], ptr %1, i64 0, i64 %16, i64 %26
  %28 = load i32, ptr %27, align 4, !tbaa !6
  %29 = icmp eq i32 %28, 0
  %30 = select i1 %29, i32 -16777216, i32 -1
  %31 = trunc i64 %26 to i32
  %32 = shl i32 %31, 3
  br label %33

33:                                               ; preds = %25, %39
  %34 = phi i32 [ 0, %25 ], [ %40, %39 ]
  %35 = add nuw nsw i32 %34, %18
  br label %42

36:                                               ; preds = %39
  %37 = add nuw nsw i64 %26, 1
  %38 = icmp eq i64 %37, 100
  br i1 %38, label %20, label %25, !llvm.loop !14

39:                                               ; preds = %42
  %40 = add nuw nsw i32 %34, 1
  %41 = icmp eq i32 %40, 8
  br i1 %41, label %36, label %33, !llvm.loop !15

42:                                               ; preds = %33, %42
  %43 = phi i32 [ 0, %33 ], [ %45, %42 ]
  %44 = add nuw nsw i32 %43, %32
  tail call void @simPutPixel(i32 noundef %44, i32 noundef %35, i32 noundef %30) #5
  %45 = add nuw nsw i32 %43, 1
  %46 = icmp eq i32 %45, 8
  br i1 %46, label %39, label %42, !llvm.loop !16

47:                                               ; preds = %19, %53
  %48 = phi i64 [ 0, %19 ], [ %54, %53 ]
  %49 = trunc nuw nsw i64 %48 to i32
  br label %50

50:                                               ; preds = %47, %86
  %51 = phi i64 [ 0, %47 ], [ %96, %86 ]
  %52 = trunc nuw nsw i64 %51 to i32
  br label %57

53:                                               ; preds = %86
  %54 = add nuw nsw i64 %48, 1
  %55 = icmp eq i64 %54, 75
  br i1 %55, label %56, label %47, !llvm.loop !17

56:                                               ; preds = %53
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(30000) %1, ptr noundef nonnull align 16 dereferenceable(30000) %2, i64 30000, i1 false), !tbaa !6
  br label %23

57:                                               ; preds = %50, %63
  %58 = phi i32 [ %83, %63 ], [ 0, %50 ]
  %59 = phi i32 [ %64, %63 ], [ -1, %50 ]
  %60 = add nsw i32 %59, %49
  %61 = icmp ult i32 %60, 75
  %62 = zext nneg i32 %60 to i64
  br label %66

63:                                               ; preds = %82
  %64 = add nsw i32 %59, 1
  %65 = icmp eq i32 %64, 2
  br i1 %65, label %86, label %57, !llvm.loop !3

66:                                               ; preds = %82, %57
  %67 = phi i32 [ %58, %57 ], [ %83, %82 ]
  %68 = phi i32 [ -1, %57 ], [ %84, %82 ]
  %69 = or i32 %68, %59
  %70 = icmp eq i32 %69, 0
  br i1 %70, label %82, label %71

71:                                               ; preds = %66
  %72 = add nsw i32 %68, %52
  %73 = icmp ult i32 %72, 100
  %74 = select i1 %73, i1 %61, i1 false
  br i1 %74, label %75, label %82

75:                                               ; preds = %71
  %76 = zext nneg i32 %72 to i64
  %77 = getelementptr inbounds nuw [100 x i32], ptr %1, i64 %62, i64 %76
  %78 = load i32, ptr %77, align 4, !tbaa !6
  %79 = icmp eq i32 %78, 1
  %80 = zext i1 %79 to i32
  %81 = add nsw i32 %67, %80
  br label %82

82:                                               ; preds = %75, %71, %66
  %83 = phi i32 [ %67, %66 ], [ %67, %71 ], [ %81, %75 ]
  %84 = add nsw i32 %68, 1
  %85 = icmp eq i32 %84, 2
  br i1 %85, label %63, label %66, !llvm.loop !10

86:                                               ; preds = %63
  %87 = getelementptr inbounds nuw [75 x [100 x i32]], ptr %1, i64 0, i64 %48, i64 %51
  %88 = load i32, ptr %87, align 4, !tbaa !6
  %89 = icmp eq i32 %88, 1
  %90 = icmp eq i32 %83, 3
  %91 = and i32 %83, -2
  %92 = icmp eq i32 %91, 2
  %93 = select i1 %89, i1 %92, i1 %90
  %94 = zext i1 %93 to i32
  %95 = getelementptr inbounds nuw [75 x [100 x i32]], ptr %2, i64 0, i64 %48, i64 %51
  store i32 %94, ptr %95, align 4, !tbaa !6
  %96 = add nuw nsw i64 %51, 1
  %97 = icmp eq i64 %96, 100
  br i1 %97, label %53, label %50, !llvm.loop !18
}

declare dso_local i32 @simRand() local_unnamed_addr #3

declare dso_local void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

declare dso_local void @simFlush(...) local_unnamed_addr #3

declare dso_local void @simDelay(i32 noundef) local_unnamed_addr #3

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #4

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: read) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { noreturn nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 2}
!2 = !{!"clang version 20.1.8 (Fedora 20.1.8-4.fc42)"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.mustprogress"}
!5 = !{!"llvm.loop.unroll.disable"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !4, !5}
!11 = distinct !{!11, !4, !5}
!12 = distinct !{!12, !4, !5}
!13 = distinct !{!13, !5}
!14 = distinct !{!14, !4, !5}
!15 = distinct !{!15, !4, !5}
!16 = distinct !{!16, !4, !5}
!17 = distinct !{!17, !4, !5}
!18 = distinct !{!18, !4, !5}
