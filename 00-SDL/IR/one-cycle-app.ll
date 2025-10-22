; ModuleID = '/home/mike/Coding/llvm-playground/00-SDL/src/one-cycle-app.c'
source_filename = "/home/mike/Coding/llvm-playground/00-SDL/src/one-cycle-app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-redhat-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @set_bound_cond(ptr nocapture noundef writeonly %0) local_unnamed_addr #0 {
  br label %3

2:                                                ; preds = %3
  ret void

3:                                                ; preds = %1, %3
  %4 = phi i64 [ 0, %1 ], [ %9, %3 ]
  %5 = tail call i32 @gui_rand() #5
  %6 = trunc i32 %5 to i8
  %7 = and i8 %6, 1
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 %4
  store i8 %7, ptr %8, align 1, !tbaa !3
  %9 = add nuw nsw i64 %4, 1
  %10 = icmp eq i64 %9, 512
  br i1 %10, label %2, label %3, !llvm.loop !7
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

declare dso_local i32 @gui_rand() local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @apply_rule(ptr nocapture noundef readonly %0, ptr nocapture noundef writeonly %1) local_unnamed_addr #3 {
  br label %4

3:                                                ; preds = %4
  ret void

4:                                                ; preds = %2, %4
  %5 = phi i64 [ 0, %2 ], [ %17, %4 ]
  %6 = add nuw i64 %5, 511
  %7 = and i64 %6, 511
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 %7
  %9 = load i8, ptr %8, align 1, !tbaa !3, !range !9, !noundef !10
  %10 = trunc nuw i8 %9 to i1
  %11 = select i1 %10, i32 4, i32 0
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 %5
  %13 = load i8, ptr %12, align 1, !tbaa !3, !range !9, !noundef !10
  %14 = trunc nuw i8 %13 to i1
  %15 = or disjoint i32 %11, 2
  %16 = select i1 %14, i32 %15, i32 %11
  %17 = add nuw nsw i64 %5, 1
  %18 = and i64 %17, 511
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 %18
  %20 = load i8, ptr %19, align 1, !tbaa !3, !range !9, !noundef !10
  %21 = zext nneg i8 %20 to i32
  %22 = or disjoint i32 %16, %21
  %23 = lshr i32 110, %22
  %24 = trunc nuw nsw i32 %23 to i8
  %25 = and i8 %24, 1
  %26 = getelementptr inbounds nuw i8, ptr %1, i64 %5
  store i8 %25, ptr %26, align 1, !tbaa !3
  %27 = icmp eq i64 %17, 512
  br i1 %27, label %3, label %4, !llvm.loop !11
}

; Function Attrs: nounwind uwtable
define dso_local void @app() local_unnamed_addr #0 {
  %1 = alloca [512 x [512 x i8]], align 16
  call void @llvm.lifetime.start.p0(i64 262144, ptr nonnull %1) #5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(262144) %1, i8 0, i64 262144, i1 false)
  br label %2

2:                                                ; preds = %2, %0
  %3 = phi i64 [ 0, %0 ], [ %8, %2 ]
  %4 = tail call i32 @gui_rand() #5
  %5 = trunc i32 %4 to i8
  %6 = and i8 %5, 1
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 %3
  store i8 %6, ptr %7, align 1, !tbaa !3
  %8 = add nuw nsw i64 %3, 1
  %9 = icmp eq i64 %8, 512
  br i1 %9, label %10, label %2, !llvm.loop !7

10:                                               ; preds = %2
  %11 = tail call i32 @gui_quit_event() #5
  %12 = getelementptr inbounds nuw i8, ptr %1, i64 512
  br label %13

13:                                               ; preds = %13, %10
  %14 = phi i64 [ 0, %10 ], [ %26, %13 ]
  %15 = add nuw nsw i64 %14, 511
  %16 = and i64 %15, 511
  %17 = getelementptr inbounds nuw i8, ptr %1, i64 %16
  %18 = load i8, ptr %17, align 1, !tbaa !3, !range !9, !noundef !10
  %19 = trunc nuw i8 %18 to i1
  %20 = select i1 %19, i8 4, i8 0
  %21 = getelementptr inbounds nuw i8, ptr %1, i64 %14
  %22 = load i8, ptr %21, align 1, !tbaa !3, !range !9, !noundef !10
  %23 = trunc nuw i8 %22 to i1
  %24 = or disjoint i8 %20, 2
  %25 = select i1 %23, i8 %24, i8 %20
  %26 = add nuw nsw i64 %14, 1
  %27 = and i64 %26, 511
  %28 = getelementptr inbounds nuw i8, ptr %1, i64 %27
  %29 = load i8, ptr %28, align 1, !tbaa !3, !range !9, !noundef !10
  %30 = or disjoint i8 %25, %29
  %31 = lshr i8 110, %30
  %32 = and i8 %31, 1
  %33 = getelementptr inbounds nuw i8, ptr %12, i64 %14
  store i8 %32, ptr %33, align 1, !tbaa !3
  %34 = icmp eq i64 %26, 512
  br i1 %34, label %35, label %13, !llvm.loop !13

35:                                               ; preds = %13, %40
  %36 = phi i64 [ %41, %40 ], [ 0, %13 ]
  %37 = trunc nuw nsw i64 %36 to i32
  %38 = trunc nuw nsw i64 %36 to i32
  br label %43

39:                                               ; preds = %40
  tail call void @gui_flush() #5
  call void @llvm.lifetime.end.p0(i64 262144, ptr nonnull %1) #5
  ret void

40:                                               ; preds = %51
  %41 = add nuw nsw i64 %36, 1
  %42 = icmp eq i64 %41, 512
  br i1 %42, label %39, label %35, !llvm.loop !14

43:                                               ; preds = %35, %51
  %44 = phi i64 [ 0, %35 ], [ %52, %51 ]
  %45 = getelementptr inbounds nuw [512 x [512 x i8]], ptr %1, i64 0, i64 %36, i64 %44
  %46 = load i8, ptr %45, align 1, !tbaa !3, !range !9, !noundef !10
  %47 = trunc nuw i8 %46 to i1
  %48 = trunc nuw nsw i64 %44 to i32
  br i1 %47, label %49, label %50

49:                                               ; preds = %43
  tail call void @gui_set_pixel(i32 noundef %48, i32 noundef %38, i32 noundef 255) #5
  br label %51

50:                                               ; preds = %43
  tail call void @gui_set_pixel(i32 noundef %48, i32 noundef %37, i32 noundef -1) #5
  br label %51

51:                                               ; preds = %49, %50
  %52 = add nuw nsw i64 %44, 1
  %53 = icmp eq i64 %52, 512
  br i1 %53, label %40, label %43, !llvm.loop !15
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #4

declare dso_local i32 @gui_quit_event() local_unnamed_addr #2

declare dso_local void @gui_set_pixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

declare dso_local void @gui_flush() local_unnamed_addr #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 2}
!2 = !{!"clang version 20.1.8 (Fedora 20.1.8-4.fc42)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"bool", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.mustprogress"}
!9 = !{i8 0, i8 2}
!10 = !{}
!11 = distinct !{!11, !8, !12}
!12 = !{!"llvm.loop.isvectorized", i32 1}
!13 = distinct !{!13, !8}
!14 = distinct !{!14, !8}
!15 = distinct !{!15, !8}
