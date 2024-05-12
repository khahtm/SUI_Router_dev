module suinami::amm_utils {
    use suinami::amm_math;


    const EParamInvalid: u64 = 1;
    const EReserveInvalid: u64 = 2;
    const EFeeInvalid: u64 = 3;
    const EAmoutInvalid: u64 = 4;


    public fun get_amount_in(
        amount_out: u64,
        reserve_in: u64,
        reserve_out: u64,
        fee_numerator: u64,
        fee_denumerator: u64
    ): u64 {
        assert!(amount_out > 0, EParamInvalid);
        assert!(reserve_in > 0 && reserve_out > 0, EReserveInvalid);
        assert!(fee_numerator > 0 && fee_denumerator > 0, EFeeInvalid);
        assert!(fee_denumerator > fee_numerator, EFeeInvalid);
        assert!(reserve_out > amount_out, EAmoutInvalid);

        let denominator = (reserve_out - amount_out) * (fee_denumerator - fee_numerator);
        amm_math::safe_mul_div_u64(amount_out * fee_denumerator, reserve_in, denominator) + 1
    }

    public fun get_amount_out(
        amount_in: u64,
        reserve_in: u64,
        reserve_out: u64,
        fee_numerator: u64,
        fee_denumerator: u64
    ): u64 {
        assert!(amount_in > 0, EParamInvalid);
        assert!(reserve_in > 0 && reserve_out > 0, EReserveInvalid);
        assert!(fee_numerator > 0 && fee_denumerator > 0, EFeeInvalid);
        assert!(fee_denumerator > fee_numerator, EFeeInvalid);

        let amount_in_with_fee = amount_in * (fee_denumerator - fee_numerator);
        let denominator = reserve_in * fee_denumerator + amount_in_with_fee;
        amm_math::safe_mul_div_u64(amount_in_with_fee, reserve_out, denominator)
    }

    public fun quote(amount_a: u64, reserve_a: u64, reserve_b: u64): u64 {
        assert!(amount_a > 0, EParamInvalid);
        assert!(reserve_a > 0 && reserve_b > 0, EParamInvalid);
        amm_math::safe_mul_div_u64(amount_a, reserve_b, reserve_a)
    }

    #[test]
    public entry fun test_get_amount_out() {
        let amount_in:u64 = 1000000;
        let reserve_in: u64 = 200006931;
        let reserve_out: u64 = 201999600;
        let out = get_amount_out(amount_in, reserve_in, reserve_out, 2, 1000);
        debug::print(&out);
        //assert!(out == 196735475, 3004);
    }
}