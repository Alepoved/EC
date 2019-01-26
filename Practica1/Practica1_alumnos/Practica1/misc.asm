.equ COEF1, 3483
	.equ COEF2, 11718
	.equ COEF3, 1183

	.text

	.extern gaussian
	.global rgb2gray
	.global div16384
	.global apply_gaussian

rgb2gray:
		push {r4-r6, lr}
		ldrb r1,[r0]
		ldrb r2,[r0,#1]
		ldrb r3,[r0,#2]
		ldr r4,=COEF1
		ldr r5,=COEF2
		ldr r6,=COEF3
		mul r4,r1,r4
		mul r5,r2,r5
		mul r6,r3,r6
		add r0,r4,r5
		add r0,r0,r6
		bl div16384
		pop {r4-r6, lr}
		mov pc,lr


div16384:
		lsr r0,r0,#14
		mov pc,lr



apply_gaussian:
		push {r4-r8, lr}
		mov r5,#0			//i
	for1:
		cmp r5,r3				//comparo
		bge finfor1
		mov r6,#0				//j
	for2:
		cmp r6,r2				//comparo
		bge finfor2
		push {r0-r3}			//guardamos la entrada de apply_gaussian
		mov r1,r2
		mov r2,r3
		mov r3,r5
		mov r4,r6
		push {r4}
		bl gaussian
		add sp,sp,#4
		mov r7, r0 				//devolicion
		pop {r0-r3}
		mul r8,r5,r2			// i*weight
		add r8,r8,r6			// i*weight + j
		strb r7,[r1,r8]			//Guardamos en img2
		add r6, r6,#1
		b for2
	finfor2:
		add r5,r5,#1
		b for1
	finfor1:
		pop {r4-r8, lr}
		mov pc,lr


  		.end

