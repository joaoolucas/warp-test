%lang starknet


from warplib.memory import wm_read_felt, wm_read_256, wm_dyn_array_length, wm_new, wm_index_dyn
from starkware.cairo.common.uint256 import uint256_sub, uint256_add, uint256_lt, Uint256, uint256_eq
from starkware.cairo.common.alloc import alloc
from warplib.maths.utils import narrow_safe, felt_to_uint256
from starkware.cairo.common.dict import dict_read, dict_write
from warplib.maths.external_input_check_ints import warp_external_input_check_int256, warp_external_input_check_int8
from warplib.maths.external_input_check_address import warp_external_input_check_address
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address
from warplib.maths.eq import warp_eq
from warplib.maths.add import warp_add256
from warplib.maths.ge import warp_ge256
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from warplib.maths.sub import warp_sub256
from warplib.maths.gt import warp_gt256
from warplib.maths.mul import warp_mul256
from warplib.maths.div import warp_div256


struct Course_758a268e{
    name : felt,
    isActive : felt,
    courseOwner : felt,
    totalStaked : Uint256,
    stakedTokenAddress : felt,
    students : felt,
    Challenges : felt,
    studentId : Uint256,
    courseId : Uint256,
}


struct Challenge_9e41769a{
    studentStatus : felt,
    studentReward : felt,
    rewardAmount : Uint256,
    challengeId : Uint256,
    storedAnswer : felt,
}


struct cd_dynarray_felt{
     len : felt ,
     ptr : felt*,
}

func wm_to_calldata0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(mem_loc: felt) -> (retData: cd_dynarray_felt){
    alloc_locals;
    let (len_256) = wm_read_256(mem_loc);
    let (ptr : felt*) = alloc();
    let (len_felt) = narrow_safe(len_256);
    wm_to_calldata1(len_felt, ptr, mem_loc + 2);
    return (cd_dynarray_felt(len=len_felt, ptr=ptr),);
}


func wm_to_calldata1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(len: felt, ptr: felt*, mem_loc: felt) -> (){
    alloc_locals;
    if (len == 0){
         return ();
    }
let (mem_read0) = wm_read_felt(mem_loc);
assert ptr[0] = mem_read0;
    wm_to_calldata1(len=len - 1, ptr=ptr + 1, mem_loc=mem_loc + 1);
    return ();
}

func wm_to_storage0_elem{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(storage_name: felt, mem_loc : felt, length: Uint256) -> (){
    alloc_locals;
    if (length.low == 0 and length.high == 0){
        return ();
    }
    let (index) = uint256_sub(length, Uint256(1,0));
    let (storage_loc) = WARP_DARRAY0_felt.read(storage_name, index);
    let mem_loc = mem_loc - 1;
    if (storage_loc == 0){
        let (storage_loc) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(storage_loc + 1);
        WARP_DARRAY0_felt.write(storage_name, index, storage_loc);
    let (copy) = dict_read{dict_ptr=warp_memory}(mem_loc);
    WARP_STORAGE.write(storage_loc, copy);
    return wm_to_storage0_elem(storage_name, mem_loc, index);
    }else{
    let (copy) = dict_read{dict_ptr=warp_memory}(mem_loc);
    WARP_STORAGE.write(storage_loc, copy);
    return wm_to_storage0_elem(storage_name, mem_loc, index);
    }
}
func wm_to_storage0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt, mem_loc : felt) -> (loc : felt){
    alloc_locals;
    let (length) = WARP_DARRAY0_felt_LENGTH.read(loc);
    let (mem_length) = wm_dyn_array_length(mem_loc);
    WARP_DARRAY0_felt_LENGTH.write(loc, mem_length);
    let (narrowedLength) = narrow_safe(mem_length);
    wm_to_storage0_elem(loc, mem_loc + 2 + 1 * narrowedLength, mem_length);
    let (lesser) = uint256_lt(mem_length, length);
    if (lesser == 1){
       WS0_DYNAMIC_ARRAY_DELETE_elem(loc, mem_length, length);
       return (loc,);
    }else{
       return (loc,);
    }
}

func WS0_DYNAMIC_ARRAY_DELETE_elem{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt, index : Uint256, length : Uint256){
     alloc_locals;
     let (stop) = uint256_eq(index, length);
     if (stop == 1){
        return ();
     }
     let (elem_loc) = WARP_DARRAY0_felt.read(loc, index);
    WS1_DELETE(elem_loc);
     let (next_index, _) = uint256_add(index, Uint256(0x1, 0x0));
     return WS0_DYNAMIC_ARRAY_DELETE_elem(loc, next_index, length);
}
func WS0_DYNAMIC_ARRAY_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt){
   alloc_locals;
   let (length) = WARP_DARRAY0_felt_LENGTH.read(loc);
   WARP_DARRAY0_felt_LENGTH.write(loc, Uint256(0x0, 0x0));
   return WS0_DYNAMIC_ARRAY_DELETE_elem(loc, Uint256(0x0, 0x0), length);
}

func WS1_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WARP_DARRAY1_Course_758a268e_IDX{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(ref: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (length) = WARP_DARRAY1_Course_758a268e_LENGTH.read(ref);
    let (inRange) = uint256_lt(index, length);
    assert inRange = 1;
    let (existing) = WARP_DARRAY1_Course_758a268e.read(ref, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 12);
        WARP_DARRAY1_Course_758a268e.write(ref, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

func WSM0_Course_758a268e_name(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM1_Course_758a268e_isActive(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WSM2_Course_758a268e_courseOwner(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WSM3_Course_758a268e_totalStaked(loc: felt) -> (memberLoc: felt){
    return (loc + 3,);
}

func WSM4_Course_758a268e_stakedTokenAddress(loc: felt) -> (memberLoc: felt){
    return (loc + 5,);
}

func WSM5_Course_758a268e_courseId(loc: felt) -> (memberLoc: felt){
    return (loc + 10,);
}

func WSM6_Course_758a268e_students(loc: felt) -> (memberLoc: felt){
    return (loc + 6,);
}

func WSM8_Course_758a268e_Challenges(loc: felt) -> (memberLoc: felt){
    return (loc + 7,);
}

func WSM12_Course_758a268e_studentId(loc: felt) -> (memberLoc: felt){
    return (loc + 8,);
}

func WSM7_Challenge_9e41769a_rewardAmount(loc: felt) -> (memberLoc: felt){
    return (loc + 2,);
}

func WSM9_Challenge_9e41769a_studentStatus(loc: felt) -> (memberLoc: felt){
    return (loc,);
}

func WSM10_Challenge_9e41769a_storedAnswer(loc: felt) -> (memberLoc: felt){
    return (loc + 6,);
}

func WSM11_Challenge_9e41769a_studentReward(loc: felt) -> (memberLoc: felt){
    return (loc + 1,);
}

func WS0_READ_warp_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = readId(loc);
    return (read0,);
}

func WS1_READ_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

func WS2_READ_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: Uint256){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    let (read1) = WARP_STORAGE.read(loc + 1);
    return (Uint256(low=read0,high=read1),);
}

func ws_to_memory0_elem{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(storage_name: felt, mem_start: felt, length: Uint256) -> (){
    alloc_locals;
    if (length.low == 0 and length.high == 0){
        return ();
    }
    let (index) = uint256_sub(length, Uint256(1,0));
    let (mem_loc) = wm_index_dyn(mem_start, index, Uint256(0x1, 0x0));
    let (element_storage_loc) = WARP_DARRAY0_felt.read(storage_name, index);
   let (copy) = WARP_STORAGE.read(element_storage_loc);
   dict_write{dict_ptr=warp_memory}(mem_loc, copy);
    return ws_to_memory0_elem(storage_name, mem_start, index);
}
func ws_to_memory0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt) -> (mem_loc : felt){
    alloc_locals;
    let (length: Uint256) = WARP_DARRAY0_felt_LENGTH.read(loc);
    let (mem_start) = wm_new(length, Uint256(0x1, 0x0));
    ws_to_memory0_elem(loc, mem_start, length);
    return (mem_start,);
}

func WS_WRITE0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: felt) -> (res: felt){
    WARP_STORAGE.write(loc, value);
    return (value,);
}

func WS_WRITE1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: Uint256) -> (res: Uint256){
    WARP_STORAGE.write(loc, value.low);
    WARP_STORAGE.write(loc + 1, value.high);
    return (value,);
}

func extern_input_check0{range_check_ptr : felt}(len: felt, ptr : felt*) -> (){
    alloc_locals;
    if (len == 0){
        return ();
    }
warp_external_input_check_int8(ptr[0]);
   extern_input_check0(len = len - 1, ptr = ptr + 1);
    return ();
}

func cd_to_memory0_elem{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(calldata: felt*, mem_start: felt, length: felt){
    alloc_locals;
    if (length == 0){
        return ();
    }
dict_write{dict_ptr=warp_memory}(mem_start, calldata[0]);
    return cd_to_memory0_elem(calldata + 1, mem_start + 1, length - 1);
}
func cd_to_memory0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(calldata : cd_dynarray_felt) -> (mem_loc: felt){
    alloc_locals;
    let (len256) = felt_to_uint256(calldata.len);
    let (mem_start) = wm_new(len256, Uint256(0x1, 0x0));
    cd_to_memory0_elem(calldata.ptr, mem_start + 2, calldata.len);
    return (mem_start,);
}

@storage_var
func WARP_DARRAY0_felt(name: felt, index: Uint256) -> (resLoc : felt){
}
@storage_var
func WARP_DARRAY0_felt_LENGTH(name: felt) -> (index: Uint256){
}

@storage_var
func WARP_DARRAY1_Course_758a268e(name: felt, index: Uint256) -> (resLoc : felt){
}
@storage_var
func WARP_DARRAY1_Course_758a268e_LENGTH(name: felt) -> (index: Uint256){
}

@storage_var
func WARP_MAPPING0(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS0_INDEX_Uint256_to_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING0.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING0.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING1(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS1_INDEX_Uint256_to_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING1.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_MAPPING1.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING2(name: felt, index: felt) -> (resLoc : felt){
}
func WS2_INDEX_felt_to_warp_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING2.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING2.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING3(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS3_INDEX_Uint256_to_Course_758a268e{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING3.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 12);
        WARP_MAPPING3.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING4(name: felt, index: felt) -> (resLoc : felt){
}
func WS4_INDEX_felt_to_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING4.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING4.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING5(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS5_INDEX_Uint256_to_Challenge_9e41769a{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING5.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 7);
        WARP_MAPPING5.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING6(name: felt, index: felt) -> (resLoc : felt){
}
func WS6_INDEX_felt_to_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING6.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_MAPPING6.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}


// Contract Def Totem


@event
func CourseAdded_81492c82(name : felt, courseOwner : felt, totalStaked : Uint256, stakedTokenAddress : felt, courseId : Uint256){
}


@event
func StudentAdded_e1cacc7b(courseId : Uint256, studentAddress : felt){
}


@event
func ChallengeAdded_fd088848(challengeId : Uint256, courseId : Uint256, challengeReward : Uint256, name : felt, question : felt, uri : felt){
}


@event
func SubmittedChallenge_0652388f(courseId : Uint256, challengeId : Uint256, answer : felt, studentAddress : felt){
}


@event
func ValidatedSubmit_08454f25(challengeId : Uint256, courseId : Uint256, score : Uint256, rewardAmount : Uint256, studentAddress : felt){
}


@event
func Claimed_b94bf7f9(challengeId : Uint256, courseId : Uint256, studentAddress : felt, reward : Uint256){
}

namespace Totem{

    // Dynamic variables - Arrays and Maps

    const __warp_0_challengeCount = 1;

    const isProfessor = 2;

    const hasAccount = 3;

    const __warp_1_courses = 4;

    const __warp_2_whitelistedTokens = 5;

    const __warp_3_accountBalances = 6;

    const __warp_8_allCourses = 7;

    // Static variables

    const __warp_4_challengeCounter = 6;

    const __warp_5_status = 8;

    const __warp_6_owner = 9;

    const __warp_7_courseCount = 10;

    const studentCount = 12;

    const _NOT_ENTERED = 15;

    const _ENTERED = 17;

    const __warp_0__status = 19;


    func __warp_constructor_1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (){
    alloc_locals;


        
        let (__warp_se_0) = get_caller_address();
        
        WS_WRITE0(__warp_6_owner, __warp_se_0);
        
        
        
        return ();

    }


    func __warp_constructor_0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (){
    alloc_locals;


        
        WS_WRITE1(__warp_0__status, Uint256(low=1, high=0));
        
        
        
        return ();

    }


    func __warp_init_ReentrancyGuard{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (){
    alloc_locals;


        
        WS_WRITE1(_NOT_ENTERED, Uint256(low=1, high=0));
        
        WS_WRITE1(_ENTERED, Uint256(low=2, high=0));
        
        
        
        return ();

    }

}


    @external
    func whitelistTokens_d7b011dc{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_9_symbol : Uint256, __warp_10_tokenAddress : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_address(__warp_10_tokenAddress);
        
        warp_external_input_check_int256(__warp_9_symbol);
        
        let (__warp_se_1) = get_caller_address();
        
        let (__warp_se_2) = WS1_READ_felt(Totem.__warp_6_owner);
        
        let (__warp_se_3) = warp_eq(__warp_se_1, __warp_se_2);
        
        with_attr error_message("This function is not public"){
            assert __warp_se_3 = 1;
        }
        
        let (__warp_se_4) = WS0_INDEX_Uint256_to_felt(Totem.__warp_2_whitelistedTokens, __warp_9_symbol);
        
        WS_WRITE0(__warp_se_4, __warp_10_tokenAddress);
        
        
        
        return ();

    }


    @external
    func depositTokens_d15b223e{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_11_amount : Uint256, __warp_12_symbol : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_12_symbol);
        
        warp_external_input_check_int256(__warp_11_amount);
        
        let __warp_cs_0 = __warp_12_symbol;
        
        let (__warp_cs_1) = get_caller_address();
        
        let (__warp_se_5) = WS2_INDEX_felt_to_warp_id(Totem.__warp_3_accountBalances, __warp_cs_1);
        
        let (__warp_se_6) = WS0_READ_warp_id(__warp_se_5);
        
        let (__warp_se_7) = WS1_INDEX_Uint256_to_Uint256(__warp_se_6, __warp_cs_0);
        
        let (__warp_se_8) = WS2_INDEX_felt_to_warp_id(Totem.__warp_3_accountBalances, __warp_cs_1);
        
        let (__warp_se_9) = WS0_READ_warp_id(__warp_se_8);
        
        let (__warp_se_10) = WS1_INDEX_Uint256_to_Uint256(__warp_se_9, __warp_cs_0);
        
        let (__warp_se_11) = WS2_READ_Uint256(__warp_se_10);
        
        let (__warp_se_12) = warp_add256(__warp_se_11, __warp_11_amount);
        
        WS_WRITE1(__warp_se_7, __warp_se_12);
        
        let (__warp_se_13) = WS0_INDEX_Uint256_to_felt(Totem.__warp_2_whitelistedTokens, __warp_12_symbol);
        
        let (__warp_se_14) = WS1_READ_felt(__warp_se_13);
        
        let (__warp_se_15) = get_caller_address();
        
        let (__warp_se_16) = get_contract_address();
        
        IERC20_warped_interface.transferFrom_23b872dd(__warp_se_14, __warp_se_15, __warp_se_16, __warp_11_amount);
        
        
        
        return ();

    }


    @external
    func withdrawTokens_8f97994b{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_13_amount : Uint256, __warp_14_symbol : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_14_symbol);
        
        warp_external_input_check_int256(__warp_13_amount);
        
        let (__warp_se_17) = get_caller_address();
        
        let (__warp_se_18) = WS2_INDEX_felt_to_warp_id(Totem.__warp_3_accountBalances, __warp_se_17);
        
        let (__warp_se_19) = WS0_READ_warp_id(__warp_se_18);
        
        let (__warp_se_20) = WS1_INDEX_Uint256_to_Uint256(__warp_se_19, __warp_14_symbol);
        
        let (__warp_se_21) = WS2_READ_Uint256(__warp_se_20);
        
        let (__warp_se_22) = warp_ge256(__warp_se_21, __warp_13_amount);
        
        with_attr error_message("Insufficient funds"){
            assert __warp_se_22 = 1;
        }
        
        let (__warp_se_23) = WS0_INDEX_Uint256_to_felt(Totem.__warp_2_whitelistedTokens, __warp_14_symbol);
        
        let (__warp_se_24) = WS1_READ_felt(__warp_se_23);
        
        let (__warp_se_25) = get_caller_address();
        
        IERC20_warped_interface.transfer_a9059cbb(__warp_se_24, __warp_se_25, __warp_13_amount);
        
        
        
        return ();

    }


    @external
    func addCourse_f1c12be0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_15_name_len : felt, __warp_15_name : felt*, __warp_16_ownerAddress : felt, __warp_17_stakeAmount : Uint256, __warp_18_tokenAddress : felt)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_address(__warp_18_tokenAddress);
        
        warp_external_input_check_int256(__warp_17_stakeAmount);
        
        warp_external_input_check_address(__warp_16_ownerAddress);
        
        extern_input_check0(__warp_15_name_len, __warp_15_name);
        
        local __warp_15_name_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_15_name_len, __warp_15_name);
        
        let (__warp_15_name_mem) = cd_to_memory0(__warp_15_name_dstruct);
        
        let (__warp_se_26) = get_caller_address();
        
        let (__warp_se_27) = get_contract_address();
        
        IERC20_warped_interface.transferFrom_23b872dd(__warp_18_tokenAddress, __warp_se_26, __warp_se_27, __warp_17_stakeAmount);
        
        let (__warp_se_28) = WS2_READ_Uint256(Totem.__warp_7_courseCount);
        
        let (__warp_se_29) = warp_add256(__warp_se_28, Uint256(low=1, high=0));
        
        let (__warp_se_30) = WS_WRITE1(Totem.__warp_7_courseCount, __warp_se_29);
        
        warp_sub256(__warp_se_30, Uint256(low=1, high=0));
        
        let (__warp_se_31) = WS2_READ_Uint256(Totem.__warp_7_courseCount);
        
        let (__warp_se_32) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_se_31);
        
        let (__warp_se_33) = WSM0_Course_758a268e_name(__warp_se_32);
        
        let (__warp_se_34) = WS0_READ_warp_id(__warp_se_33);
        
        wm_to_storage0(__warp_se_34, __warp_15_name_mem);
        
        let (__warp_se_35) = WS2_READ_Uint256(Totem.__warp_7_courseCount);
        
        let (__warp_se_36) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_se_35);
        
        let (__warp_se_37) = WSM1_Course_758a268e_isActive(__warp_se_36);
        
        WS_WRITE0(__warp_se_37, 1);
        
        let (__warp_se_38) = WS2_READ_Uint256(Totem.__warp_7_courseCount);
        
        let (__warp_se_39) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_se_38);
        
        let (__warp_se_40) = WSM2_Course_758a268e_courseOwner(__warp_se_39);
        
        WS_WRITE0(__warp_se_40, __warp_16_ownerAddress);
        
        let (__warp_se_41) = WS2_READ_Uint256(Totem.__warp_7_courseCount);
        
        let (__warp_se_42) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_se_41);
        
        let (__warp_se_43) = WSM3_Course_758a268e_totalStaked(__warp_se_42);
        
        WS_WRITE1(__warp_se_43, __warp_17_stakeAmount);
        
        let (__warp_se_44) = WS2_READ_Uint256(Totem.__warp_7_courseCount);
        
        let (__warp_se_45) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_se_44);
        
        let (__warp_se_46) = WSM4_Course_758a268e_stakedTokenAddress(__warp_se_45);
        
        WS_WRITE0(__warp_se_46, __warp_18_tokenAddress);
        
        let (__warp_se_47) = WS2_READ_Uint256(Totem.__warp_7_courseCount);
        
        let (__warp_se_48) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_se_47);
        
        let (__warp_se_49) = WSM5_Course_758a268e_courseId(__warp_se_48);
        
        let (__warp_se_50) = WS2_READ_Uint256(Totem.__warp_7_courseCount);
        
        WS_WRITE1(__warp_se_49, __warp_se_50);
        
        let (__warp_se_51) = WS2_READ_Uint256(Totem.__warp_7_courseCount);
        
        CourseAdded_81492c82.emit(__warp_15_name_mem, __warp_16_ownerAddress, __warp_17_stakeAmount, __warp_18_tokenAddress, __warp_se_51);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func addStudents_84a70c72{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_19_studentAddress : felt, __warp_20_courseId : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_20_courseId);
        
        warp_external_input_check_address(__warp_19_studentAddress);
        
        let (__warp_se_52) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_20_courseId);
        
        let (__warp_se_53) = WSM2_Course_758a268e_courseOwner(__warp_se_52);
        
        let (__warp_se_54) = WS1_READ_felt(__warp_se_53);
        
        let (__warp_se_55) = get_caller_address();
        
        let (__warp_se_56) = warp_eq(__warp_se_54, __warp_se_55);
        
        with_attr error_message("You're not the professor of this Course"){
            assert __warp_se_56 = 1;
        }
        
        let (__warp_se_57) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_20_courseId);
        
        let (__warp_se_58) = WSM6_Course_758a268e_students(__warp_se_57);
        
        let (__warp_se_59) = WS0_READ_warp_id(__warp_se_58);
        
        let (__warp_se_60) = WS4_INDEX_felt_to_felt(__warp_se_59, __warp_19_studentAddress);
        
        WS_WRITE0(__warp_se_60, 1);
        
        StudentAdded_e1cacc7b.emit(__warp_20_courseId, __warp_19_studentAddress);
        
        
        
        return ();

    }


    @external
    func addChallenge_a157cded{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_21_courseId : Uint256, __warp_22_challengeReward : Uint256, __warp_23_name_len : felt, __warp_23_name : felt*, __warp_24_question_len : felt, __warp_24_question : felt*, __warp_25_uri_len : felt, __warp_25_uri : felt*)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        extern_input_check0(__warp_25_uri_len, __warp_25_uri);
        
        extern_input_check0(__warp_24_question_len, __warp_24_question);
        
        extern_input_check0(__warp_23_name_len, __warp_23_name);
        
        warp_external_input_check_int256(__warp_22_challengeReward);
        
        warp_external_input_check_int256(__warp_21_courseId);
        
        local __warp_25_uri_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_25_uri_len, __warp_25_uri);
        
        let (__warp_25_uri_mem) = cd_to_memory0(__warp_25_uri_dstruct);
        
        local __warp_24_question_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_24_question_len, __warp_24_question);
        
        let (__warp_24_question_mem) = cd_to_memory0(__warp_24_question_dstruct);
        
        local __warp_23_name_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_23_name_len, __warp_23_name);
        
        let (__warp_23_name_mem) = cd_to_memory0(__warp_23_name_dstruct);
        
        let (__warp_se_61) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_21_courseId);
        
        let (__warp_se_62) = WSM2_Course_758a268e_courseOwner(__warp_se_61);
        
        let (__warp_se_63) = WS1_READ_felt(__warp_se_62);
        
        let (__warp_se_64) = get_caller_address();
        
        let (__warp_se_65) = warp_eq(__warp_se_63, __warp_se_64);
        
        with_attr error_message("You're not the professor of this Course"){
            assert __warp_se_65 = 1;
        }
        
        let (__warp_se_66) = WS2_READ_Uint256(Totem.__warp_4_challengeCounter);
        
        let (__warp_se_67) = warp_add256(__warp_se_66, Uint256(low=1, high=0));
        
        let (__warp_se_68) = WS_WRITE1(Totem.__warp_4_challengeCounter, __warp_se_67);
        
        warp_sub256(__warp_se_68, Uint256(low=1, high=0));
        
        let (__warp_se_69) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_21_courseId);
        
        let (__warp_se_70) = WSM8_Course_758a268e_Challenges(__warp_se_69);
        
        let (__warp_se_71) = WS0_READ_warp_id(__warp_se_70);
        
        let (__warp_se_72) = WS2_READ_Uint256(Totem.__warp_4_challengeCounter);
        
        let (__warp_se_73) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_71, __warp_se_72);
        
        let (__warp_se_74) = WSM7_Challenge_9e41769a_rewardAmount(__warp_se_73);
        
        WS_WRITE1(__warp_se_74, __warp_22_challengeReward);
        
        let (__warp_se_75) = WS2_READ_Uint256(Totem.__warp_4_challengeCounter);
        
        ChallengeAdded_fd088848.emit(__warp_se_75, __warp_21_courseId, __warp_22_challengeReward, __warp_23_name_mem, __warp_24_question_mem, __warp_25_uri_mem);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func submitChallenge_c49cf7f3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_26_answer_len : felt, __warp_26_answer : felt*, __warp_27_courseId : Uint256, __warp_28_challengeId : Uint256)-> (){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int256(__warp_28_challengeId);
        
        warp_external_input_check_int256(__warp_27_courseId);
        
        extern_input_check0(__warp_26_answer_len, __warp_26_answer);
        
        local __warp_26_answer_dstruct : cd_dynarray_felt = cd_dynarray_felt(__warp_26_answer_len, __warp_26_answer);
        
        let (__warp_26_answer_mem) = cd_to_memory0(__warp_26_answer_dstruct);
        
        let __warp_pse_0 = 1;
        
        let (__warp_se_76) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_27_courseId);
        
        let (__warp_se_77) = WSM6_Course_758a268e_students(__warp_se_76);
        
        let (__warp_se_78) = WS0_READ_warp_id(__warp_se_77);
        
        let (__warp_se_79) = get_caller_address();
        
        let (__warp_se_80) = WS4_INDEX_felt_to_felt(__warp_se_78, __warp_se_79);
        
        WS_WRITE0(__warp_se_80, __warp_pse_0);
        
        with_attr error_message("Address not a student of this Course"){
            assert __warp_pse_0 = 1;
        }
        
        let (__warp_se_81) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_27_courseId);
        
        let (__warp_se_82) = WSM8_Course_758a268e_Challenges(__warp_se_81);
        
        let (__warp_se_83) = WS0_READ_warp_id(__warp_se_82);
        
        let (__warp_se_84) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_83, __warp_28_challengeId);
        
        let (__warp_se_85) = WSM7_Challenge_9e41769a_rewardAmount(__warp_se_84);
        
        let (__warp_se_86) = WS2_READ_Uint256(__warp_se_85);
        
        let (__warp_se_87) = warp_gt256(__warp_se_86, Uint256(low=0, high=0));
        
        with_attr error_message("Challenge doesnt Exist"){
            assert __warp_se_87 = 1;
        }
        
        let (__warp_se_88) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_27_courseId);
        
        let (__warp_se_89) = WSM8_Course_758a268e_Challenges(__warp_se_88);
        
        let (__warp_se_90) = WS0_READ_warp_id(__warp_se_89);
        
        let (__warp_se_91) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_90, __warp_28_challengeId);
        
        let (__warp_se_92) = WSM9_Challenge_9e41769a_studentStatus(__warp_se_91);
        
        let (__warp_se_93) = WS0_READ_warp_id(__warp_se_92);
        
        let (__warp_se_94) = get_caller_address();
        
        let (__warp_se_95) = WS4_INDEX_felt_to_felt(__warp_se_93, __warp_se_94);
        
        WS_WRITE0(__warp_se_95, 1);
        
        let (__warp_se_96) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_27_courseId);
        
        let (__warp_se_97) = WSM8_Course_758a268e_Challenges(__warp_se_96);
        
        let (__warp_se_98) = WS0_READ_warp_id(__warp_se_97);
        
        let (__warp_se_99) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_98, __warp_28_challengeId);
        
        let (__warp_se_100) = WSM10_Challenge_9e41769a_storedAnswer(__warp_se_99);
        
        let (__warp_se_101) = WS0_READ_warp_id(__warp_se_100);
        
        let (__warp_se_102) = get_caller_address();
        
        let (__warp_se_103) = WS2_INDEX_felt_to_warp_id(__warp_se_101, __warp_se_102);
        
        let (__warp_se_104) = WS0_READ_warp_id(__warp_se_103);
        
        wm_to_storage0(__warp_se_104, __warp_26_answer_mem);
        
        let (__warp_se_105) = get_caller_address();
        
        SubmittedChallenge_0652388f.emit(__warp_27_courseId, __warp_28_challengeId, __warp_26_answer_mem, __warp_se_105);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @external
    func validateSubmit_9ce5db26{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_29_challengeId : Uint256, __warp_30_courseId : Uint256, __warp_31_score : Uint256, __warp_32_studentAddress : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_address(__warp_32_studentAddress);
        
        warp_external_input_check_int256(__warp_31_score);
        
        warp_external_input_check_int256(__warp_30_courseId);
        
        warp_external_input_check_int256(__warp_29_challengeId);
        
        let (__warp_se_106) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_30_courseId);
        
        let (__warp_se_107) = WSM2_Course_758a268e_courseOwner(__warp_se_106);
        
        let (__warp_se_108) = WS1_READ_felt(__warp_se_107);
        
        let (__warp_se_109) = get_caller_address();
        
        let (__warp_se_110) = warp_eq(__warp_se_108, __warp_se_109);
        
        with_attr error_message("You're not the professor of this Course"){
            assert __warp_se_110 = 1;
        }
        
        let (__warp_se_111) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_30_courseId);
        
        let (__warp_se_112) = WSM8_Course_758a268e_Challenges(__warp_se_111);
        
        let (__warp_se_113) = WS0_READ_warp_id(__warp_se_112);
        
        let (__warp_se_114) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_113, __warp_29_challengeId);
        
        let (__warp_se_115) = WSM9_Challenge_9e41769a_studentStatus(__warp_se_114);
        
        let (__warp_se_116) = WS0_READ_warp_id(__warp_se_115);
        
        let (__warp_se_117) = WS4_INDEX_felt_to_felt(__warp_se_116, __warp_32_studentAddress);
        
        let (__warp_se_118) = WS1_READ_felt(__warp_se_117);
        
        let (__warp_se_119) = warp_eq(__warp_se_118, 1);
        
        assert __warp_se_119 = 1;
        
        let (__warp_se_120) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_30_courseId);
        
        let (__warp_se_121) = WSM8_Course_758a268e_Challenges(__warp_se_120);
        
        let (__warp_se_122) = WS0_READ_warp_id(__warp_se_121);
        
        let (__warp_se_123) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_122, __warp_29_challengeId);
        
        let (__warp_se_124) = WSM9_Challenge_9e41769a_studentStatus(__warp_se_123);
        
        let (__warp_se_125) = WS0_READ_warp_id(__warp_se_124);
        
        let (__warp_se_126) = WS4_INDEX_felt_to_felt(__warp_se_125, __warp_32_studentAddress);
        
        WS_WRITE0(__warp_se_126, 2);
        
        let (__warp_se_127) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_30_courseId);
        
        let (__warp_se_128) = WSM8_Course_758a268e_Challenges(__warp_se_127);
        
        let (__warp_se_129) = WS0_READ_warp_id(__warp_se_128);
        
        let (__warp_se_130) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_129, __warp_29_challengeId);
        
        let (__warp_se_131) = WSM11_Challenge_9e41769a_studentReward(__warp_se_130);
        
        let (__warp_se_132) = WS0_READ_warp_id(__warp_se_131);
        
        let (__warp_se_133) = WS6_INDEX_felt_to_Uint256(__warp_se_132, __warp_32_studentAddress);
        
        let (__warp_se_134) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_30_courseId);
        
        let (__warp_se_135) = WSM8_Course_758a268e_Challenges(__warp_se_134);
        
        let (__warp_se_136) = WS0_READ_warp_id(__warp_se_135);
        
        let (__warp_se_137) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_136, __warp_29_challengeId);
        
        let (__warp_se_138) = WSM7_Challenge_9e41769a_rewardAmount(__warp_se_137);
        
        let (__warp_se_139) = WS2_READ_Uint256(__warp_se_138);
        
        let (__warp_se_140) = warp_mul256(__warp_31_score, __warp_se_139);
        
        let (__warp_se_141) = warp_div256(__warp_se_140, Uint256(low=100, high=0));
        
        WS_WRITE1(__warp_se_133, __warp_se_141);
        
        let (__warp_se_142) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_30_courseId);
        
        let (__warp_se_143) = WSM8_Course_758a268e_Challenges(__warp_se_142);
        
        let (__warp_se_144) = WS0_READ_warp_id(__warp_se_143);
        
        let (__warp_se_145) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_144, __warp_29_challengeId);
        
        let (__warp_se_146) = WSM7_Challenge_9e41769a_rewardAmount(__warp_se_145);
        
        let (__warp_se_147) = WS2_READ_Uint256(__warp_se_146);
        
        ValidatedSubmit_08454f25.emit(__warp_29_challengeId, __warp_30_courseId, __warp_31_score, __warp_se_147, __warp_32_studentAddress);
        
        
        
        return ();

    }


    @external
    func Claim_022e3d29{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_33_challengeId : Uint256, __warp_34_courseId : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_34_courseId);
        
        warp_external_input_check_int256(__warp_33_challengeId);
        
        let (__warp_se_148) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_34_courseId);
        
        let (__warp_se_149) = WSM8_Course_758a268e_Challenges(__warp_se_148);
        
        let (__warp_se_150) = WS0_READ_warp_id(__warp_se_149);
        
        let (__warp_se_151) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_150, __warp_33_challengeId);
        
        let (__warp_se_152) = WSM9_Challenge_9e41769a_studentStatus(__warp_se_151);
        
        let (__warp_se_153) = WS0_READ_warp_id(__warp_se_152);
        
        let (__warp_se_154) = get_caller_address();
        
        let (__warp_se_155) = WS4_INDEX_felt_to_felt(__warp_se_153, __warp_se_154);
        
        let (__warp_se_156) = WS1_READ_felt(__warp_se_155);
        
        let (__warp_se_157) = warp_eq(__warp_se_156, 2);
        
        assert __warp_se_157 = 1;
        
        let (__warp_se_158) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_34_courseId);
        
        let (__warp_se_159) = WSM8_Course_758a268e_Challenges(__warp_se_158);
        
        let (__warp_se_160) = WS0_READ_warp_id(__warp_se_159);
        
        let (__warp_se_161) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_160, __warp_33_challengeId);
        
        let (__warp_se_162) = WSM9_Challenge_9e41769a_studentStatus(__warp_se_161);
        
        let (__warp_se_163) = WS0_READ_warp_id(__warp_se_162);
        
        let (__warp_se_164) = get_caller_address();
        
        let (__warp_se_165) = WS4_INDEX_felt_to_felt(__warp_se_163, __warp_se_164);
        
        WS_WRITE0(__warp_se_165, 3);
        
        let (__warp_se_166) = WS2_READ_Uint256(Totem.__warp_7_courseCount);
        
        let (__warp_se_167) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_se_166);
        
        let (__warp_se_168) = WSM4_Course_758a268e_stakedTokenAddress(__warp_se_167);
        
        let (__warp_se_169) = WS1_READ_felt(__warp_se_168);
        
        let (__warp_se_170) = get_caller_address();
        
        let (__warp_se_171) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_34_courseId);
        
        let (__warp_se_172) = WSM8_Course_758a268e_Challenges(__warp_se_171);
        
        let (__warp_se_173) = WS0_READ_warp_id(__warp_se_172);
        
        let (__warp_se_174) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_173, __warp_33_challengeId);
        
        let (__warp_se_175) = WSM11_Challenge_9e41769a_studentReward(__warp_se_174);
        
        let (__warp_se_176) = WS0_READ_warp_id(__warp_se_175);
        
        let (__warp_se_177) = get_caller_address();
        
        let (__warp_se_178) = WS6_INDEX_felt_to_Uint256(__warp_se_176, __warp_se_177);
        
        let (__warp_se_179) = WS2_READ_Uint256(__warp_se_178);
        
        IERC20_warped_interface.transfer_a9059cbb(__warp_se_169, __warp_se_170, __warp_se_179);
        
        let (__warp_se_180) = get_caller_address();
        
        let (__warp_se_181) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_34_courseId);
        
        let (__warp_se_182) = WSM8_Course_758a268e_Challenges(__warp_se_181);
        
        let (__warp_se_183) = WS0_READ_warp_id(__warp_se_182);
        
        let (__warp_se_184) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_183, __warp_33_challengeId);
        
        let (__warp_se_185) = WSM7_Challenge_9e41769a_rewardAmount(__warp_se_184);
        
        let (__warp_se_186) = WS2_READ_Uint256(__warp_se_185);
        
        Claimed_b94bf7f9.emit(__warp_33_challengeId, __warp_34_courseId, __warp_se_180, __warp_se_186);
        
        
        
        return ();

    }


    @view
    func getChallengeReward_35713e44{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_35_courseId : Uint256, __warp_36_challengeId : Uint256)-> (reward : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_36_challengeId);
        
        warp_external_input_check_int256(__warp_35_courseId);
        
        let (__warp_se_187) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_35_courseId);
        
        let (__warp_se_188) = WSM8_Course_758a268e_Challenges(__warp_se_187);
        
        let (__warp_se_189) = WS0_READ_warp_id(__warp_se_188);
        
        let (__warp_se_190) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_189, __warp_36_challengeId);
        
        let (__warp_se_191) = WSM7_Challenge_9e41769a_rewardAmount(__warp_se_190);
        
        let (__warp_se_192) = WS2_READ_Uint256(__warp_se_191);
        
        
        
        return (__warp_se_192,);

    }


    @view
    func getStudentReward_1996afab{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_37_courseId : Uint256, __warp_38_challengeId : Uint256, __warp_39_studentAddress : felt)-> (reward : Uint256){
    alloc_locals;


        
        warp_external_input_check_address(__warp_39_studentAddress);
        
        warp_external_input_check_int256(__warp_38_challengeId);
        
        warp_external_input_check_int256(__warp_37_courseId);
        
        let (__warp_se_193) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_37_courseId);
        
        let (__warp_se_194) = WSM8_Course_758a268e_Challenges(__warp_se_193);
        
        let (__warp_se_195) = WS0_READ_warp_id(__warp_se_194);
        
        let (__warp_se_196) = WS5_INDEX_Uint256_to_Challenge_9e41769a(__warp_se_195, __warp_38_challengeId);
        
        let (__warp_se_197) = WSM11_Challenge_9e41769a_studentReward(__warp_se_196);
        
        let (__warp_se_198) = WS0_READ_warp_id(__warp_se_197);
        
        let (__warp_se_199) = WS6_INDEX_felt_to_Uint256(__warp_se_198, __warp_39_studentAddress);
        
        let (__warp_se_200) = WS2_READ_Uint256(__warp_se_199);
        
        
        
        return (__warp_se_200,);

    }


    @view
    func challengeCount_1f422587{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_40__i0 : Uint256)-> (__warp_41 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_40__i0);
        
        let (__warp_se_201) = WS1_INDEX_Uint256_to_Uint256(Totem.__warp_0_challengeCount, __warp_40__i0);
        
        let (__warp_se_202) = WS2_READ_Uint256(__warp_se_201);
        
        
        
        return (__warp_se_202,);

    }


    @view
    func courses_96f979d2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_42__i0 : Uint256)-> (__warp_43_len : felt, __warp_43 : felt*, __warp_44 : felt, __warp_45 : felt, __warp_46 : Uint256, __warp_47 : felt, __warp_48 : Uint256, __warp_49 : Uint256){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int256(__warp_42__i0);
        
        let (__warp_50__temp0) = WS3_INDEX_Uint256_to_Course_758a268e(Totem.__warp_1_courses, __warp_42__i0);
        
        let (__warp_se_203) = WSM0_Course_758a268e_name(__warp_50__temp0);
        
        let (__warp_se_204) = WS0_READ_warp_id(__warp_se_203);
        
        let (__warp_43) = ws_to_memory0(__warp_se_204);
        
        let (__warp_se_205) = WSM1_Course_758a268e_isActive(__warp_50__temp0);
        
        let (__warp_44) = WS1_READ_felt(__warp_se_205);
        
        let (__warp_se_206) = WSM2_Course_758a268e_courseOwner(__warp_50__temp0);
        
        let (__warp_45) = WS1_READ_felt(__warp_se_206);
        
        let (__warp_se_207) = WSM3_Course_758a268e_totalStaked(__warp_50__temp0);
        
        let (__warp_46) = WS2_READ_Uint256(__warp_se_207);
        
        let (__warp_se_208) = WSM4_Course_758a268e_stakedTokenAddress(__warp_50__temp0);
        
        let (__warp_47) = WS1_READ_felt(__warp_se_208);
        
        let (__warp_se_209) = WSM12_Course_758a268e_studentId(__warp_50__temp0);
        
        let (__warp_48) = WS2_READ_Uint256(__warp_se_209);
        
        let (__warp_se_210) = WSM5_Course_758a268e_courseId(__warp_50__temp0);
        
        let (__warp_49) = WS2_READ_Uint256(__warp_se_210);
        
        let (__warp_se_211) = wm_to_calldata0(__warp_43);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return (__warp_se_211.len, __warp_se_211.ptr, __warp_44, __warp_45, __warp_46, __warp_47, __warp_48, __warp_49);
    }
    }


    @view
    func whitelistedTokens_aa3d9a15{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_51__i0 : Uint256)-> (__warp_52 : felt){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_51__i0);
        
        let (__warp_se_212) = WS0_INDEX_Uint256_to_felt(Totem.__warp_2_whitelistedTokens, __warp_51__i0);
        
        let (__warp_se_213) = WS1_READ_felt(__warp_se_212);
        
        
        
        return (__warp_se_213,);

    }


    @view
    func accountBalances_e64fe366{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_53__i0 : felt, __warp_54__i1 : Uint256)-> (__warp_55 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_54__i1);
        
        warp_external_input_check_address(__warp_53__i0);
        
        let (__warp_se_214) = WS2_INDEX_felt_to_warp_id(Totem.__warp_3_accountBalances, __warp_53__i0);
        
        let (__warp_se_215) = WS0_READ_warp_id(__warp_se_214);
        
        let (__warp_se_216) = WS1_INDEX_Uint256_to_Uint256(__warp_se_215, __warp_54__i1);
        
        let (__warp_se_217) = WS2_READ_Uint256(__warp_se_216);
        
        
        
        return (__warp_se_217,);

    }


    @view
    func challengeCounter_f7fed02c{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_56 : Uint256){
    alloc_locals;


        
        let (__warp_se_218) = WS2_READ_Uint256(Totem.__warp_4_challengeCounter);
        
        
        
        return (__warp_se_218,);

    }


    @view
    func status_200d2ed2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_57 : felt){
    alloc_locals;


        
        let (__warp_se_219) = WS1_READ_felt(Totem.__warp_5_status);
        
        
        
        return (__warp_se_219,);

    }


    @view
    func allCourses_cb88dc79{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_58__i0 : Uint256)-> (__warp_59_len : felt, __warp_59 : felt*, __warp_60 : felt, __warp_61 : felt, __warp_62 : Uint256, __warp_63 : felt, __warp_64 : Uint256, __warp_65 : Uint256){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int256(__warp_58__i0);
        
        let (__warp_66__temp0) = WARP_DARRAY1_Course_758a268e_IDX(Totem.__warp_8_allCourses, __warp_58__i0);
        
        let (__warp_se_220) = WSM0_Course_758a268e_name(__warp_66__temp0);
        
        let (__warp_se_221) = WS0_READ_warp_id(__warp_se_220);
        
        let (__warp_59) = ws_to_memory0(__warp_se_221);
        
        let (__warp_se_222) = WSM1_Course_758a268e_isActive(__warp_66__temp0);
        
        let (__warp_60) = WS1_READ_felt(__warp_se_222);
        
        let (__warp_se_223) = WSM2_Course_758a268e_courseOwner(__warp_66__temp0);
        
        let (__warp_61) = WS1_READ_felt(__warp_se_223);
        
        let (__warp_se_224) = WSM3_Course_758a268e_totalStaked(__warp_66__temp0);
        
        let (__warp_62) = WS2_READ_Uint256(__warp_se_224);
        
        let (__warp_se_225) = WSM4_Course_758a268e_stakedTokenAddress(__warp_66__temp0);
        
        let (__warp_63) = WS1_READ_felt(__warp_se_225);
        
        let (__warp_se_226) = WSM12_Course_758a268e_studentId(__warp_66__temp0);
        
        let (__warp_64) = WS2_READ_Uint256(__warp_se_226);
        
        let (__warp_se_227) = WSM5_Course_758a268e_courseId(__warp_66__temp0);
        
        let (__warp_65) = WS2_READ_Uint256(__warp_se_227);
        
        let (__warp_se_228) = wm_to_calldata0(__warp_59);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return (__warp_se_228.len, __warp_se_228.ptr, __warp_60, __warp_61, __warp_62, __warp_63, __warp_64, __warp_65);
    }
    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(){
    alloc_locals;
    WARP_USED_STORAGE.write(21);
    WARP_NAMEGEN.write(7);


        
        Totem.__warp_init_ReentrancyGuard();
        
        Totem.__warp_constructor_0();
        
        Totem.__warp_constructor_1();
        
        
        
        return ();

    }

@storage_var
func WARP_STORAGE(index: felt) -> (val: felt){
}
@storage_var
func WARP_USED_STORAGE() -> (val: felt){
}
@storage_var
func WARP_NAMEGEN() -> (name: felt){
}
func readId{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (val: felt){
    alloc_locals;
    let (id) = WARP_STORAGE.read(loc);
    if (id == 0){
        let (id) = WARP_NAMEGEN.read();
        WARP_NAMEGEN.write(id + 1);
        WARP_STORAGE.write(loc, id + 1);
        return (id + 1,);
    }else{
        return (id,);
    }
}


// Contract Def IERC20@interface


@contract_interface
namespace IERC20_warped_interface{
func balanceOf_70a08231(account : felt)-> (__warp_0 : Uint256){
}
func transferFrom_23b872dd(__warp_1_from : felt, to : felt, amount : Uint256)-> (__warp_2 : felt){
}
func approve_095ea7b3(spender : felt, amount : Uint256)-> (__warp_3 : felt){
}
func transfer_a9059cbb(to : felt, amount : Uint256)-> (__warp_4 : felt){
}
}