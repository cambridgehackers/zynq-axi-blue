/*****************************************************************************
* Filename:          /home/oriol/MIT/projects/ZedBoard/project_bcl/project_bcl.srcs/sources_1/edk/module_bcl/drivers/bcl_glue_v1_00_a/src/bcl_glue_selftest.c
* Version:           1.00.a
* Description:       Contains a diagnostic self-test function for the bcl_glue driver
* Date:              Mon Oct 15 17:26:59 2012 (by Create and Import Peripheral Wizard)
*****************************************************************************/


/***************************** Include Files *******************************/

#include "bcl_glue.h"
#include "stdio.h"
//#include "xio.h"
#include "xparameters.h"
#include "xil_cache.h"

/************************** Constant Definitions ***************************/

#define READ_WRITE_MUL_FACTOR 0x10
#define BCL_GLUE_SELFTEST_BUFSIZE  64 /* Size of buffer (for transfer test) in bytes */
#define BCL_GLUE_USER_NUM_REG  4/* Number of registers in slave */

/************************** Variable Definitions ****************************/

static Xuint8 __attribute__((aligned (128))) SrcBuffer[BCL_GLUE_SELFTEST_BUFSIZE];   /* Source buffer      */
static Xuint8 __attribute__((aligned (128))) DstBuffer[BCL_GLUE_SELFTEST_BUFSIZE];   /* Destination buffer */

/************************** Function Definitions ***************************/

/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the BCL_GLUE instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus BCL_GLUE_SelfTest(void * baseaddr_p)
{
  Xuint32 baseaddr;
  int write_loop_index;
  int read_loop_index;
  int Index;
  
  /*
   * Check and get the device address
   */
  /*
   * Base Address maybe 0. Up to developer to uncomment line below.
  XASSERT_NONVOID(baseaddr_p != XNULL);
   */
  baseaddr = (Xuint32) baseaddr_p;

  xil_printf("******************************\n\r");
  xil_printf("* User Peripheral Self Test\n\r");
  xil_printf("******************************\n\n\r");

  /*
   * Write to user logic slave module register(s) and read back
   */
  xil_printf("User logic slave module test...\n\r");

  for (write_loop_index = 0 ; write_loop_index < BCL_GLUE_USER_NUM_REG; write_loop_index++)
    BCL_GLUE_mWriteSlaveReg0 (baseaddr, write_loop_index*4, (write_loop_index+1)*READ_WRITE_MUL_FACTOR);
  for (read_loop_index = 0 ; read_loop_index < BCL_GLUE_USER_NUM_REG; read_loop_index++)
    if ( BCL_GLUE_mReadSlaveReg0 (baseaddr, read_loop_index*4) != (read_loop_index+1)*READ_WRITE_MUL_FACTOR){
      xil_printf ("Error reading register value at address %x", (int)baseaddr + read_loop_index*4);
      return XST_FAILURE;
    }

  xil_printf("   - slave register write/read passed\n\n\r");

  /* Read the registers at the base address to ensure that this is indeed working */
  /*
  if ( (BCL_GLUE_mReadSlaveReg0 (baseaddr, 0)) != 0x0){
    xil_printf("   - soft reset failed\n\n\r");
    return XST_FAILURE;
  }

  xil_printf("   - soft reset passed\n\n\r");
  */
  
  /*
   * Setup user logic master module to receive/send data from/to remote memory
   */
  xil_printf("User logic master module test...\n\r");
  xil_printf("   - source buffer address is 0x%08x\n\r", SrcBuffer);
  xil_printf("   - destination buffer address is 0x%08x\n\r", DstBuffer);
  xil_printf("   - initialize the source buffer bytes with a pattern\n\r");
  xil_printf("   - initialize the destination buffer bytes to zero\n\r");
  /*
  *  Initialize the buffer to be used for testing. Note that this
  * buffer should be accessible from both processor as well as
  * Master */

  for ( Index = 0; Index < BCL_GLUE_SELFTEST_BUFSIZE; Index++ )
  {
    SrcBuffer[Index] = Index;
    DstBuffer[Index] = 0;
  }
  
  Xil_DCacheFlushRange((unsigned int) SrcBuffer, BCL_GLUE_SELFTEST_BUFSIZE*sizeof(Xuint8));
  Xil_DCacheFlushRange((unsigned int) DstBuffer, BCL_GLUE_SELFTEST_BUFSIZE*sizeof(Xuint8));
  
  xil_printf("   - start user logic master module to receive word from the source\n\r");
  BCL_GLUE_MasterRecvBytes(baseaddr, (Xuint32) SrcBuffer, BCL_GLUE_SELFTEST_BUFSIZE);
  while ( ! BCL_GLUE_mMasterDone(baseaddr) ) {}
  xil_printf("   - transfer completed\n\r");
  xil_printf("   - start user logic master module to send word to the destination\n\r");
  BCL_GLUE_MasterSendBytes(baseaddr, (Xuint32) DstBuffer, BCL_GLUE_SELFTEST_BUFSIZE);
  while ( ! BCL_GLUE_mMasterDone(baseaddr) ) {}
  xil_printf("   - transfer completed\n\r");

  for ( Index = 0; Index < BCL_GLUE_SELFTEST_BUFSIZE; Index++ )
  {
    if ( DstBuffer[Index] != SrcBuffer[Index] )
    {
      xil_printf("   - destination buffer byte %d is different from the source buffer\n\r", Index);
      xil_printf("   - master module data transfer failed\n\r");
      return XST_FAILURE;
    }
  }
  xil_printf("   - destination buffer's contents are same as the source buffer\n\r");
  xil_printf("   - master module data transfer passed\n\n\r");

  return XST_SUCCESS;
}
