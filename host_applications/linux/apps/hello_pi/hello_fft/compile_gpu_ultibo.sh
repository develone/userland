#!/bin/bash
rm -f *.o
arm-none-eabi-gcc -mabi=aapcs -marm -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard -c gpu_fft_shaders.c 
arm-none-eabi-gcc -mabi=aapcs -marm -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard -c gpu_fft_twiddles.c
arm-none-eabi-gcc -DULTIBO -mabi=aapcs -marm -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard -c hello_fft_2d.c 
arm-none-eabi-gcc -mabi=aapcs -marm -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard -c gpu_fft.c 
arm-none-eabi-gcc -mabi=aapcs -marm -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard -c gpu_fft_trans.c 
arm-none-eabi-gcc -DULTIBO -mabi=aapcs -marm -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard -c gpu_fft_base.c
#Need to provide gpu_fft_ptr_inc code that does this function
#unsigned  (
#    struct GPU_FFT_PTR *ptr,
#    int bytes) {

#    unsigned vc = ptr->vc;
#    ptr->vc += bytes;
#    ptr->arm.bptr += bytes;
#    return vc;
#}
#This will require a new unit

arm-none-eabi-ar rcs libgpufft.a *.o
arm-none-eabi-ar t libgpufft.a > libgpufft_obj.txt
echo "The objects in the libgpufft"
cat libgpufft_obj.txt
arm-none-eabi-objdump -d libgpufft.a > dis_libgpufft.txt
fpc -vi -B -Tultibo -Parm -CpARMV7A -WpRPI2B @/home/pi/ultibo/core/fpc/bin/rpi2.cfg -O4 LibC_GPUFFT_RPi2.lpr
ls -la libgpufft.a kernel7.img *.o
