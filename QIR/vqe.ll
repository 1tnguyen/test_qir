
%Result = type opaque
%Range = type { i64, i64, i64 }
%Array = type opaque
%Qubit = type opaque
%Tuple = type opaque
%String = type opaque

@ResultZero = external global %Result*
@ResultOne = external global %Result*
@PauliI = constant i2 0
@PauliX = constant i2 1
@PauliY = constant i2 -1
@PauliZ = constant i2 -2
@EmptyRange = internal constant %Range { i64 0, i64 1, i64 -1 }

define double @Sample__VQE__EstimateFrequency__body(%Array* %state1, %Array* %state2, double %phase, %Array* %measurementOps, i64 %nTrials) {
entry:
  call void @__quantum__rt__array_update_alias_count(%Array* %state1, i64 1)
  call void @__quantum__rt__array_update_alias_count(%Array* %state2, i64 1)
  call void @__quantum__rt__array_update_alias_count(%Array* %measurementOps, i64 1)
  %nUp = alloca i64
  store i64 0, i64* %nUp
  %nQubits = call i64 @__quantum__rt__array_get_size_1d(%Array* %measurementOps)
  %0 = sub i64 %nTrials, 1
  br label %header__1

header__1:                                        ; preds = %exiting__1, %entry
  %idxMeasurement = phi i64 [ 0, %entry ], [ %8, %exiting__1 ]
  %1 = icmp sle i64 %idxMeasurement, %0
  br i1 %1, label %body__1, label %exit__1

body__1:                                          ; preds = %header__1
  %register = call %Array* @__quantum__rt__qubit_allocate_array(i64 %nQubits)
  call void @__quantum__rt__array_update_alias_count(%Array* %register, i64 1)
  call void @Sample__VQE__PrepareTrialState__body(%Array* %state1, %Array* %state2, double %phase, %Array* %register)
  call void @__quantum__rt__array_update_alias_count(%Array* %measurementOps, i64 1)
  call void @__quantum__rt__array_update_alias_count(%Array* %register, i64 1)
  %result = call %Result* @__quantum__qis__measure__body(%Array* %measurementOps, %Array* %register)
  call void @__quantum__rt__array_update_alias_count(%Array* %measurementOps, i64 -1)
  call void @__quantum__rt__array_update_alias_count(%Array* %register, i64 -1)
  %2 = load %Result*, %Result** @ResultZero
  %3 = call i1 @__quantum__rt__result_equal(%Result* %result, %Result* %2)
  br i1 %3, label %then0__1, label %continue__1

then0__1:                                         ; preds = %body__1
  %4 = load i64, i64* %nUp
  %5 = add i64 %4, 1
  store i64 %5, i64* %nUp
  br label %continue__1

continue__1:                                      ; preds = %then0__1, %body__1
  %6 = call i64 @__quantum__rt__array_get_size_1d(%Array* %register)
  %7 = sub i64 %6, 1
  br label %header__2

exiting__1:                                       ; preds = %exit__2
  %8 = add i64 %idxMeasurement, 1
  br label %header__1

exit__1:                                          ; preds = %header__1
  %i = load i64, i64* %nUp
  %9 = call double @__quantum__qis__intasdouble__body(i64 %i)
  %10 = call double @__quantum__qis__intasdouble__body(i64 %nTrials)
  %11 = fdiv double %9, %10
  call void @__quantum__rt__array_update_alias_count(%Array* %state1, i64 -1)
  call void @__quantum__rt__array_update_alias_count(%Array* %state2, i64 -1)
  call void @__quantum__rt__array_update_alias_count(%Array* %measurementOps, i64 -1)
  ret double %11

header__2:                                        ; preds = %exiting__2, %continue__1
  %12 = phi i64 [ 0, %continue__1 ], [ %19, %exiting__2 ]
  %13 = icmp sle i64 %12, %7
  br i1 %13, label %body__2, label %exit__2

body__2:                                          ; preds = %header__2
  %14 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %register, i64 %12)
  %15 = bitcast i8* %14 to %Qubit**
  %r = load %Qubit*, %Qubit** %15
  %16 = call %Result* @__quantum__qis__mz(%Qubit* %r)
  %17 = load %Result*, %Result** @ResultOne
  %18 = call i1 @__quantum__rt__result_equal(%Result* %16, %Result* %17)
  br i1 %18, label %then0__2, label %continue__2

then0__2:                                         ; preds = %body__2
  call void @__quantum__qis__x__body(%Qubit* %r)
  br label %continue__2

continue__2:                                      ; preds = %then0__2, %body__2
  call void @__quantum__rt__result_update_reference_count(%Result* %16, i64 -1)
  br label %exiting__2

exiting__2:                                       ; preds = %continue__2
  %19 = add i64 %12, 1
  br label %header__2

exit__2:                                          ; preds = %header__2
  call void @__quantum__rt__qubit_release_array(%Array* %register)
  call void @__quantum__rt__array_update_alias_count(%Array* %register, i64 -1)
  call void @__quantum__rt__array_update_reference_count(%Array* %register, i64 -1)
  call void @__quantum__rt__result_update_reference_count(%Result* %result, i64 -1)
  br label %exiting__1
}

declare void @__quantum__rt__array_update_alias_count(%Array*, i64)

declare i64 @__quantum__rt__array_get_size_1d(%Array*)

declare %Qubit* @__quantum__rt__qubit_allocate()

declare %Array* @__quantum__rt__qubit_allocate_array(i64)

define void @Sample__VQE__PrepareTrialState__body(%Array* %state1, %Array* %state2, double %phase, %Array* %qubits) {
entry:
  call void @__quantum__rt__array_update_alias_count(%Array* %state1, i64 1)
  call void @__quantum__rt__array_update_alias_count(%Array* %state2, i64 1)
  call void @__quantum__rt__array_update_alias_count(%Array* %qubits, i64 1)
  %aux = call %Array* @__quantum__rt__qubit_allocate_array(i64 2)
  call void @__quantum__rt__array_update_alias_count(%Array* %aux, i64 1)
  %0 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %aux, i64 0)
  %1 = bitcast i8* %0 to %Qubit**
  %qb = load %Qubit*, %Qubit** %1
  call void @__quantum__qis__h__body(%Qubit* %qb)
  %2 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %aux, i64 0)
  %3 = bitcast i8* %2 to %Qubit**
  %qb__1 = load %Qubit*, %Qubit** %3
  call void @__quantum__qis__rz__body(double %phase, %Qubit* %qb__1)
  %4 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %aux, i64 0)
  %5 = bitcast i8* %4 to %Qubit**
  %control = load %Qubit*, %Qubit** %5
  %6 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %aux, i64 1)
  %7 = bitcast i8* %6 to %Qubit**
  %target = load %Qubit*, %Qubit** %7
  call void @__quantum__qis__cnot__body(%Qubit* %control, %Qubit* %target)
  %8 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %aux, i64 0)
  %9 = bitcast i8* %8 to %Qubit**
  %qb__3 = load %Qubit*, %Qubit** %9
  call void @__quantum__qis__x__body(%Qubit* %qb__3)
  %10 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %aux, i64 1)
  %11 = bitcast i8* %10 to %Qubit**
  %qb__4 = load %Qubit*, %Qubit** %11
  call void @__quantum__qis__x__body(%Qubit* %qb__4)
  %12 = call i64 @__quantum__rt__array_get_size_1d(%Array* %state1)
  %13 = sub i64 %12, 1
  br label %header__1

header__1:                                        ; preds = %exiting__1, %entry
  %14 = phi i64 [ 0, %entry ], [ %20, %exiting__1 ]
  %15 = icmp sle i64 %14, %13
  br i1 %15, label %body__1, label %exit__1

body__1:                                          ; preds = %header__1
  %16 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %state1, i64 %14)
  %17 = bitcast i8* %16 to i64*
  %__qsVar0__n__ = load i64, i64* %17
  %18 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %qubits, i64 %__qsVar0__n__)
  %19 = bitcast i8* %18 to %Qubit**
  %qb__5 = load %Qubit*, %Qubit** %19
  call void @__quantum__qis__x__body(%Qubit* %qb__5)
  br label %exiting__1

exiting__1:                                       ; preds = %body__1
  %20 = add i64 %14, 1
  br label %header__1

exit__1:                                          ; preds = %header__1
  %21 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %aux, i64 1)
  %22 = bitcast i8* %21 to %Qubit**
  %qb__6 = load %Qubit*, %Qubit** %22
  call void @__quantum__qis__x__body(%Qubit* %qb__6)
  %23 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %aux, i64 0)
  %24 = bitcast i8* %23 to %Qubit**
  %qb__7 = load %Qubit*, %Qubit** %24
  call void @__quantum__qis__x__body(%Qubit* %qb__7)
  %25 = call i64 @__quantum__rt__array_get_size_1d(%Array* %state2)
  %26 = sub i64 %25, 1
  br label %header__2

header__2:                                        ; preds = %exiting__2, %exit__1
  %27 = phi i64 [ 0, %exit__1 ], [ %33, %exiting__2 ]
  %28 = icmp sle i64 %27, %26
  br i1 %28, label %body__2, label %exit__2

body__2:                                          ; preds = %header__2
  %29 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %state2, i64 %27)
  %30 = bitcast i8* %29 to i64*
  %n = load i64, i64* %30
  %31 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %qubits, i64 %n)
  %32 = bitcast i8* %31 to %Qubit**
  %qb__8 = load %Qubit*, %Qubit** %32
  call void @__quantum__qis__x__body(%Qubit* %qb__8)
  br label %exiting__2

exiting__2:                                       ; preds = %body__2
  %33 = add i64 %27, 1
  br label %header__2

exit__2:                                          ; preds = %header__2
  %34 = call i64 @__quantum__rt__array_get_size_1d(%Array* %aux)
  %35 = sub i64 %34, 1
  br label %header__3

header__3:                                        ; preds = %exiting__3, %exit__2
  %36 = phi i64 [ 0, %exit__2 ], [ %43, %exiting__3 ]
  %37 = icmp sle i64 %36, %35
  br i1 %37, label %body__3, label %exit__3

body__3:                                          ; preds = %header__3
  %38 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %aux, i64 %36)
  %39 = bitcast i8* %38 to %Qubit**
  %a = load %Qubit*, %Qubit** %39
  %40 = call %Result* @__quantum__qis__mz(%Qubit* %a)
  %41 = load %Result*, %Result** @ResultOne
  %42 = call i1 @__quantum__rt__result_equal(%Result* %40, %Result* %41)
  br i1 %42, label %then0__1, label %continue__1

then0__1:                                         ; preds = %body__3
  call void @__quantum__qis__x__body(%Qubit* %a)
  br label %continue__1

continue__1:                                      ; preds = %then0__1, %body__3
  call void @__quantum__rt__result_update_reference_count(%Result* %40, i64 -1)
  br label %exiting__3

exiting__3:                                       ; preds = %continue__1
  %43 = add i64 %36, 1
  br label %header__3

exit__3:                                          ; preds = %header__3
  call void @__quantum__rt__qubit_release_array(%Array* %aux)
  call void @__quantum__rt__array_update_alias_count(%Array* %aux, i64 -1)
  call void @__quantum__rt__array_update_reference_count(%Array* %aux, i64 -1)
  call void @__quantum__rt__array_update_alias_count(%Array* %state1, i64 -1)
  call void @__quantum__rt__array_update_alias_count(%Array* %state2, i64 -1)
  call void @__quantum__rt__array_update_alias_count(%Array* %qubits, i64 -1)
  ret void
}

declare %Result* @__quantum__qis__measure__body(%Array*, %Array*)

declare i1 @__quantum__rt__result_equal(%Result*, %Result*)

declare i8* @__quantum__rt__array_get_element_ptr_1d(%Array*, i64)

declare %Result* @__quantum__qis__mz(%Qubit*)

declare void @__quantum__qis__x__body(%Qubit*)

declare void @__quantum__rt__result_update_reference_count(%Result*, i64)

declare void @__quantum__rt__qubit_release_array(%Array*)

declare void @__quantum__rt__array_update_reference_count(%Array*, i64)

declare double @__quantum__qis__intasdouble__body(i64)

define double @Sample__VQE__EstimateTermExpectation__body(%Array* %state1, %Array* %state2, double %phase, %Array* %ops, double %coeff, i64 %nSamples) {
entry:
  call void @__quantum__rt__array_update_alias_count(%Array* %state1, i64 1)
  call void @__quantum__rt__array_update_alias_count(%Array* %state2, i64 1)
  call void @__quantum__rt__array_update_alias_count(%Array* %ops, i64 1)
  %jwTermEnergy = alloca double
  store double 0.000000e+00, double* %jwTermEnergy
  %termExpectation = call double @Sample__VQE__EstimateFrequency__body(%Array* %state1, %Array* %state2, double %phase, %Array* %ops, i64 %nSamples)
  %0 = fmul double 2.000000e+00, %termExpectation
  %1 = fsub double %0, 1.000000e+00
  %2 = fmul double %1, %coeff
  %3 = fadd double 0.000000e+00, %2
  store double %3, double* %jwTermEnergy
  call void @__quantum__rt__array_update_alias_count(%Array* %state1, i64 -1)
  call void @__quantum__rt__array_update_alias_count(%Array* %state2, i64 -1)
  call void @__quantum__rt__array_update_alias_count(%Array* %ops, i64 -1)
  ret double %3
}

declare void @__quantum__qis__h__body(%Qubit*)

declare void @__quantum__qis__rz__body(double, %Qubit*)

declare void @__quantum__qis__cnot__body(%Qubit*, %Qubit*)

define void @Microsoft__Quantum__Intrinsic__CNOT__body(%Qubit* %control, %Qubit* %target) {
entry:
  call void @__quantum__qis__cnot__body(%Qubit* %control, %Qubit* %target)
  ret void
}

define void @Microsoft__Quantum__Intrinsic__CNOT__adj(%Qubit* %control, %Qubit* %target) {
entry:
  call void @__quantum__qis__cnot__body(%Qubit* %control, %Qubit* %target)
  ret void
}

define void @Microsoft__Quantum__Intrinsic__H__body(%Qubit* %qb) {
entry:
  call void @__quantum__qis__h__body(%Qubit* %qb)
  ret void
}

define void @Microsoft__Quantum__Intrinsic__H__adj(%Qubit* %qb) {
entry:
  call void @__quantum__qis__h__body(%Qubit* %qb)
  ret void
}

define double @Microsoft__Quantum__Intrinsic__IntAsDouble__body(i64 %i) {
entry:
  %0 = call double @__quantum__qis__intasdouble__body(i64 %i)
  ret double %0
}

define %Result* @Microsoft__Quantum__Intrinsic__Measure__body(%Array* %bases, %Array* %qubits) {
entry:
  call void @__quantum__rt__array_update_alias_count(%Array* %bases, i64 1)
  call void @__quantum__rt__array_update_alias_count(%Array* %qubits, i64 1)
  %0 = call %Result* @__quantum__qis__measure__body(%Array* %bases, %Array* %qubits)
  call void @__quantum__rt__array_update_alias_count(%Array* %bases, i64 -1)
  call void @__quantum__rt__array_update_alias_count(%Array* %qubits, i64 -1)
  ret %Result* %0
}

define %Result* @Microsoft__Quantum__Intrinsic__MResetZ__body(%Qubit* %qb) {
entry:
  %res = call %Result* @__quantum__qis__mz(%Qubit* %qb)
  %0 = load %Result*, %Result** @ResultOne
  %1 = call i1 @__quantum__rt__result_equal(%Result* %res, %Result* %0)
  br i1 %1, label %then0__1, label %continue__1

then0__1:                                         ; preds = %entry
  call void @__quantum__qis__x__body(%Qubit* %qb)
  br label %continue__1

continue__1:                                      ; preds = %then0__1, %entry
  ret %Result* %res
}

define double @Microsoft__Quantum__Intrinsic__PI__body() {
entry:
  ret double 0x400921FB5443D5FC
}

define void @Microsoft__Quantum__Intrinsic__Rx__body(double %theta, %Qubit* %qb) {
entry:
  call void @__quantum__qis__rx__body(double %theta, %Qubit* %qb)
  ret void
}

declare void @__quantum__qis__rx__body(double, %Qubit*)

define void @Microsoft__Quantum__Intrinsic__Rx__adj(double %theta, %Qubit* %qb) {
entry:
  %theta__1 = fneg double %theta
  call void @__quantum__qis__rx__body(double %theta__1, %Qubit* %qb)
  ret void
}

define void @Microsoft__Quantum__Intrinsic__Rz__body(double %theta, %Qubit* %qb) {
entry:
  call void @__quantum__qis__rz__body(double %theta, %Qubit* %qb)
  ret void
}

define void @Microsoft__Quantum__Intrinsic__Rz__adj(double %theta, %Qubit* %qb) {
entry:
  %theta__1 = fneg double %theta
  call void @__quantum__qis__rz__body(double %theta__1, %Qubit* %qb)
  ret void
}

define void @Microsoft__Quantum__Intrinsic__Rz__ctl(%Array* %ctls, { double, %Qubit* }* %0) {
entry:
  call void @__quantum__rt__array_update_alias_count(%Array* %ctls, i64 1)
  %1 = getelementptr { double, %Qubit* }, { double, %Qubit* }* %0, i64 0, i32 0
  %theta = load double, double* %1
  %2 = getelementptr { double, %Qubit* }, { double, %Qubit* }* %0, i64 0, i32 1
  %qb = load %Qubit*, %Qubit** %2
  %theta__1 = fdiv double %theta, 2.000000e+00
  call void @__quantum__qis__rz__body(double %theta__1, %Qubit* %qb)
  %3 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %ctls, i64 0)
  %4 = bitcast i8* %3 to %Qubit**
  %control = load %Qubit*, %Qubit** %4
  call void @__quantum__qis__cnot__body(%Qubit* %control, %Qubit* %qb)
  %5 = fneg double %theta
  %theta__2 = fdiv double %5, 2.000000e+00
  call void @__quantum__qis__rz__body(double %theta__2, %Qubit* %qb)
  %6 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %ctls, i64 0)
  %7 = bitcast i8* %6 to %Qubit**
  %control__1 = load %Qubit*, %Qubit** %7
  call void @__quantum__qis__cnot__body(%Qubit* %control__1, %Qubit* %qb)
  call void @__quantum__rt__array_update_alias_count(%Array* %ctls, i64 -1)
  ret void
}

define void @Microsoft__Quantum__Intrinsic__Rz__ctladj(%Array* %ctls, { double, %Qubit* }* %0) {
entry:
  call void @__quantum__rt__array_update_alias_count(%Array* %ctls, i64 1)
  %1 = getelementptr { double, %Qubit* }, { double, %Qubit* }* %0, i64 0, i32 0
  %theta = load double, double* %1
  %2 = getelementptr { double, %Qubit* }, { double, %Qubit* }* %0, i64 0, i32 1
  %qb = load %Qubit*, %Qubit** %2
  %3 = fneg double %theta
  %theta__1 = fdiv double %3, 2.000000e+00
  call void @__quantum__qis__rz__body(double %theta__1, %Qubit* %qb)
  %4 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %ctls, i64 0)
  %5 = bitcast i8* %4 to %Qubit**
  %control = load %Qubit*, %Qubit** %5
  call void @__quantum__qis__cnot__body(%Qubit* %control, %Qubit* %qb)
  %theta__2 = fdiv double %theta, 2.000000e+00
  call void @__quantum__qis__rz__body(double %theta__2, %Qubit* %qb)
  %6 = call i8* @__quantum__rt__array_get_element_ptr_1d(%Array* %ctls, i64 0)
  %7 = bitcast i8* %6 to %Qubit**
  %control__1 = load %Qubit*, %Qubit** %7
  call void @__quantum__qis__cnot__body(%Qubit* %control__1, %Qubit* %qb)
  call void @__quantum__rt__array_update_alias_count(%Array* %ctls, i64 -1)
  ret void
}

define void @Microsoft__Quantum__Intrinsic__S__body(%Qubit* %qb) {
entry:
  call void @__quantum__qis__s__body(%Qubit* %qb)
  ret void
}

declare void @__quantum__qis__s__body(%Qubit*)

define void @Microsoft__Quantum__Intrinsic__S__adj(%Qubit* %qb) {
entry:
  call void @__quantum__qis__s__body(%Qubit* %qb)
  call void @__quantum__qis__z__body(%Qubit* %qb)
  ret void
}

declare void @__quantum__qis__z__body(%Qubit*)

define void @Microsoft__Quantum__Intrinsic__T__body(%Qubit* %qb) {
entry:
  call void @__quantum__qis__t__body(%Qubit* %qb)
  ret void
}

declare void @__quantum__qis__t__body(%Qubit*)

define void @Microsoft__Quantum__Intrinsic__T__adj(%Qubit* %qb) {
entry:
  call void @__quantum__qis__t__adj(%Qubit* %qb)
  ret void
}

declare void @__quantum__qis__t__adj(%Qubit*)

define void @Microsoft__Quantum__Intrinsic__X__body(%Qubit* %qb) {
entry:
  call void @__quantum__qis__x__body(%Qubit* %qb)
  ret void
}

define void @Microsoft__Quantum__Intrinsic__X__adj(%Qubit* %qb) {
entry:
  call void @__quantum__qis__x__body(%Qubit* %qb)
  ret void
}

define void @Microsoft__Quantum__Intrinsic__Z__body(%Qubit* %qb) {
entry:
  call void @__quantum__qis__z__body(%Qubit* %qb)
  ret void
}

define void @Microsoft__Quantum__Intrinsic__Z__adj(%Qubit* %qb) {
entry:
  call void @__quantum__qis__z__body(%Qubit* %qb)
  ret void
}

define void @Microsoft__Quantum__Instructions__Rx__body(double %theta, %Qubit* %qb) {
entry:
  call void @__quantum__qis__rx__body(double %theta, %Qubit* %qb)
  ret void
}

define void @Microsoft__Quantum__Instructions__Rz__body(double %theta, %Qubit* %qb) {
entry:
  call void @__quantum__qis__rz__body(double %theta, %Qubit* %qb)
  ret void
}

define void @Microsoft__Quantum__Instructions__S__body(%Qubit* %qb) {
entry:
  call void @__quantum__qis__s__body(%Qubit* %qb)
  ret void
}

define %Tuple* @Microsoft__Quantum__Core__Attribute__body() {
entry:
  ret %Tuple* null
}

define %Tuple* @Microsoft__Quantum__Core__EntryPoint__body() {
entry:
  ret %Tuple* null
}

define %Tuple* @Microsoft__Quantum__Core__Inline__body() {
entry:
  ret %Tuple* null
}

define { %String* }* @Microsoft__Quantum__Targeting__TargetInstruction__body(%String* %__Item1__) {
entry:
  %0 = call %Tuple* @__quantum__rt__tuple_create(i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %1 = bitcast %Tuple* %0 to { %String* }*
  %2 = getelementptr { %String* }, { %String* }* %1, i64 0, i32 0
  store %String* %__Item1__, %String** %2
  call void @__quantum__rt__string_update_reference_count(%String* %__Item1__, i64 1)
  ret { %String* }* %1
}

declare %Tuple* @__quantum__rt__tuple_create(i64)

declare void @__quantum__rt__string_update_reference_count(%String*, i64)
