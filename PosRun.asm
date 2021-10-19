#finds the length of the longest consecutive run of positive values in array
#Tristan Chilvers | Alex Muse

.text #text section
.globl main #call main by SPIM

main:
    # Register assignments:
    # s0 = list
    # s1 = size
    # t2 is count = 0, t3 is maxrun = 0, t4 is k = 0, t5 is array counter

    #========== Initialize Registers ===========================================
    la $s0, list                # store address of list into s0
    la $s1, size                # store address of size into s1
    syscall

    # Call Function
    jal posrun                  # go to posrun function
    move $s2, $v0               # move result to s2

    move $a0, $s2               # move result to a0 to print
    li $v0, 1                   # print data in a0
    syscall

    li $v0, 10                  # terminate program
    syscall

    #===========================================================================
    #===========================================================================
    # FUNCTION: int posrun(int list[], int size)
    # Arguments stored in $s0 and $s1
    # Return value stored in $v0
    # Return address stored in $ra (done by jal function)
posrun:
    lw $t1, 0($s1)              # store size of array into t1
    j for_loop                  # go to for_loop

for_loop:
    beq $t4, $t1, exit          # if k is equal to size, then exit (k < size)

                                # if (list[k] > 0)
    lw  $t7, list($t5)          # load list[k] into t7
    slt $t6, $t7, $zero         # if list[k] < 0, t6 = 1; if not then t6 = 0
    beq $t6, $zero, countAdd    # if (list[k] > 0) is true, then go to countAdd
    beq $t6, 1, setZero         # if (list[k] > 0) is false, then go to setZero

    #============ IF STATEMENTS ================================================
countAdd:
    addi $t2, $t2, 1            # count = count + 1
    slt $t6, $t3, $t2           # if maxrun < count
    beq $t6, 1, setMaxrun       # then set maxrun to count
    j return                    # jump to return

setZero:
    li $t2, 0                   # count = 0
    slt $t6, $t3, $t2           # if maxrun < count
    beq $t6, 1, setMaxrun       # then set maxrun to count
    j return                    # jump to return

setMaxrun:
    move $t3, $t2               # maxrun = count
    j return                    # jump to return

    #===========================================================================
return:
    addi $t5, $t5, 4            # offset the array counter by 4 (since data is stored 4 apart in word)
    addi $t4, $t4, 1            # add 1 to value at t4   (k++)
    j for_loop                  # jump to beginning of for_loop

exit:
    move $v0, $t3               # save value for maxrun in v0
    jr $ra                      # return to saved address (in main)

    #===========================================================================
    #===========================================================================


.data #data section
list: .word 3, 0, 1, 2, 6, -2, 4, 7, 3, 7   # array data
size: .word 10                              # size of array is 10
