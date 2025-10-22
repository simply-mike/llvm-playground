; ModuleID = '/home/mike/Coding/llvm-playground/00-SDL/src/app.c'
source_filename = "/home/mike/Coding/llvm-playground/00-SDL/src/app.c"
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
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %13, label %65

13:                                               ; preds = %10, %48
  %14 = phi i32 [ %18, %48 ], [ 0, %10 ]
  %15 = and i32 %14, 511
  %16 = zext nneg i32 %15 to i64
  %17 = getelementptr inbounds nuw [512 x [512 x i8]], ptr %1, i64 0, i64 %16
  %18 = add nuw nsw i32 %14, 1
  %19 = and i32 %18, 511
  %20 = zext nneg i32 %19 to i64
  %21 = getelementptr inbounds nuw [512 x [512 x i8]], ptr %1, i64 0, i64 %20
  br label %22

22:                                               ; preds = %13, %22
  %23 = phi i64 [ 0, %13 ], [ %35, %22 ]
  %24 = add nuw nsw i64 %23, 511
  %25 = and i64 %24, 511
  %26 = getelementptr inbounds nuw i8, ptr %17, i64 %25
  %27 = load i8, ptr %26, align 1, !tbaa !3, !range !9, !noundef !10
  %28 = trunc nuw i8 %27 to i1
  %29 = select i1 %28, i8 4, i8 0
  %30 = getelementptr inbounds nuw i8, ptr %17, i64 %23
  %31 = load i8, ptr %30, align 1, !tbaa !3, !range !9, !noundef !10
  %32 = trunc nuw i8 %31 to i1
  %33 = or disjoint i8 %29, 2
  %34 = select i1 %32, i8 %33, i8 %29
  %35 = add nuw nsw i64 %23, 1
  %36 = and i64 %35, 511
  %37 = getelementptr inbounds nuw i8, ptr %17, i64 %36
  %38 = load i8, ptr %37, align 1, !tbaa !3, !range !9, !noundef !10
  %39 = or disjoint i8 %34, %38
  %40 = lshr i8 110, %39
  %41 = and i8 %40, 1
  %42 = getelementptr inbounds nuw i8, ptr %21, i64 %23
  store i8 %41, ptr %42, align 1, !tbaa !3
  %43 = icmp eq i64 %35, 512
  br i1 %43, label %44, label %22, !llvm.loop !13

44:                                               ; preds = %22, %51
  %45 = phi i64 [ %52, %51 ], [ 0, %22 ]
  %46 = trunc nuw nsw i64 %45 to i32
  %47 = trunc nuw nsw i64 %45 to i32
  br label %54

48:                                               ; preds = %51
  tail call void @gui_flush() #5
  %49 = tail call i32 @gui_quit_event() #5
  %50 = icmp eq i32 %49, 0
  br i1 %50, label %13, label %65

51:                                               ; preds = %62
  %52 = add nuw nsw i64 %45, 1
  %53 = icmp eq i64 %52, 512
  br i1 %53, label %48, label %44, !llvm.loop !14

54:                                               ; preds = %44, %62
  %55 = phi i64 [ 0, %44 ], [ %63, %62 ]
  %56 = getelementptr inbounds nuw [512 x [512 x i8]], ptr %1, i64 0, i64 %45, i64 %55
  %57 = load i8, ptr %56, align 1, !tbaa !3, !range !9, !noundef !10
  %58 = trunc nuw i8 %57 to i1
  %59 = trunc nuw nsw i64 %55 to i32
  br i1 %58, label %60, label %61

60:                                               ; preds = %54
  tail call void @gui_set_pixel(i32 noundef %59, i32 noundef %47, i32 noundef 255) #5
  br label %62

61:                                               ; preds = %54
  tail call void @gui_set_pixel(i32 noundef %59, i32 noundef %46, i32 noundef -1) #5
  br label %62

62:                                               ; preds = %60, %61
  %63 = add nuw nsw i64 %55, 1
  %64 = icmp eq i64 %63, 512
  br i1 %64, label %51, label %54, !llvm.loop !15

65:                                               ; preds = %48, %10
  call void @llvm.lifetime.end.p0(i64 262144, ptr nonnull %1) #5
  ret void
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
!13 = distinct !{!13, !8, !12}
!14 = distinct !{!14, !8}
!15 = distinct !{!15, !8}
