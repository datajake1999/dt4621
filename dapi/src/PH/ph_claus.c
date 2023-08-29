/* 
 ***********************************************************************
 *
 *                           Copyright �
 *    Copyright � 2000-2001 Force Computer, Inc., a Solectron company. All rights reserved.
 *    � Digital Equipment Corporation 1996, 1997,1998, 1999 All rights reserved.
 *
 *    U.S. Government Rights: Consistent with FAR 12.211 and 12.212, 
 *    Commercial Computer Software, Computer Software Documentation, 
 *    and Technical Data for Commercial Items are licensed to the U.S. 
 *    Government under vendor's standard commercial license.
 *
 *    This software is proprietary to and embodies the confidential
 *    technology of Force Computers Incoporated and other parties.
 *    Possession, use, or copying of this software and media is authorized
 *    only pursuant to a valid written license from Force or an
 *    authorized sublicensor.
 *
 ***********************************************************************
 *    File Name:    ph_claus.c
 *    Author:
 *    Creation Date:
 *
 *    Functionality:
 * 	  Synthesize a clause from phonemic ascii input
 *    Assumes all voice changing commands have been removed
 *    and acted upon by higher-level code.
 *    Assumes optional user-specified durations in user_durs[]
 *    Assumes optional user-specified f0\notes in user_f0[]
 *
 ***********************************************************************
 *    Revision History:
 *
 * Rev  Who     Date            Description
 * ---  -----   -----------     -------------------------------------------- 
 * 0001 DK		09/01/1984	    Initial creation
 * 0002 DGC		12/27/1984      Modified as required for 80186.
 * 0003 DK		07/84/1985      Add one-frame delay to all pars except AV,T0,TL
 * 0004 DGC		08/08/1985	    Haltsw (FLAG) => halting (short), new sync.
#ifdef ENGLISH_US from phclaus.c
 * 0005 CJL		02/15/1996	    Removed all KRM code. 
 * 0006 MGS		03/25/1996	    Merged WIN 95 code with 42c
#endif
#ifdef SPANISH  from sphclaus.c
 * 0005 MM		03/26/1986	    Dennis' changes
 * 0006 DF		06/02/1986	    DT3 updates: nbrphone -> nphonetot (Eng. base)
 * 0007 MM 		07/11/1986	    Merge 68000 updates (trillend)
#endif
#ifdef GERMAN 	from gphclaus.c
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 * 0005 BNK		07/21/1986	    allow use of german phonemes
 * 0006 BNK		09/12/1986	    variable initialization
 * 0007 BNK		01/12/1987	    prepare link to bk-package
 * 0008 CJL		03/30/1995	    File was phclause.c. Is now gphclaus.c. Changed
 *                      		phdefs.h->gphdefs.h
#endif
 * 0008 MGS		05/31/1996	 	Mergd spanish with english
 * 0009	MGS		06/06/1996		Changed file name from phcluase.c to ph_claus.c
 * 0010 MGS		06/17/1996		Merged German with english/spanish 
 * 0011 SIK		07/09/1996  	Cleaning up and maintenance
 * 0012 EDB		01/10/1997		remove some comment.
 * 0013	GL		03/27/1997		for BATS#319 
 *                              add 0800 debug switch.
 * 0014	GL		04/21/1997		BATS#357  Add the code for __osf__ build 
 * 0015	GL		04/21/1997		BATS#360  remove spaces before "#define" or "#if" 
 * 0016 TQL		06/03/1997		Fix an incorrect #if statement
 * 0017 DR		09/30/1997		UK BUILD: added UK STUFF
 * 0018 EAB		10/19/1997		remove the SPANISH trillend code
 * 0019 GL		12/12/1997		add the code for UK_English to support LINKRWORD
 * 0020 EAB     03/11/1998      Added new VTM control parameters enabled in dectalkf.h with NEW_VTM
 * 0021 CJL     03/20/1998      Fix include path for dectalkf.h
 * 0022	gl		03/25/1998		Added DBGV command for PH debug variable passing
 *								For BATS#639 to change phinton() to use argument phTTS instead of pDph_t
 * 0023 EAB		07/13/1998		bats 711 EAB Added tilt safety code
 * 0024 EAB		07/15/1998		Need lineartilt until we can fix the tilt filter BATS 17
 * 0025 EAB     10/13/1998		Add in OLD_TILT to switch out linear array with new filter
 * 0026 EAB		01/25/1999		Improved UK linkr in phsort code so that ends_in_r no_longer needed
 * 0027 EAB		02/13/1999		Added new vaiables for SWAPDATA (EVAN BALLABAN) and openq which 
								I haven't decided how to ifdef out yet
 * 0028 EAB		02/18/1999      Add in support OUT_BR (BREATHINESS) and number_verbs  initalization
 * 0029 EAB 	02/23/1999 		Updated copyright notice and added boiler plate init of number_words
   0030 EAB		05/2/1999		BATS 887 Output phon and duration info into parstochip from here where the tie alignment is correct.
								phdwt0 expects a time delay through filters....
 * 0031 EAB 	04/07/2000		EAB removed istrill
 * 0032 MGS		04/13/2000		Changes for integrated phoneme set 
 * 0033 EAB		06/28/2000		Unified Phoneme Set Changes
 * 0034 CHJ		07/20/2000		French added
 * 0035 EAB		07/28/2000		Added ouput of phone+1 for SAPI
 * 0036 CAB		10/18/2000		Changed copyright info and formatted comments
 * 0036 CAB 	01/16/2001		Merged Michel Divay changes for French
 * 0037 CAB		01/22/2001		Fix compile error by adding #endif for define FRENCH
 * 0038 CAB		01/26/2001		Added sections Michel removed from file
 * 0039 CAB		02/09/2001		Added additional changes by Michel
 * 0040 CAB		03/21/2001		Added changes by michel
 * 0041 CAB		03/27/2001		Comment out #define DEBG 1
 */	

#include "ph_def.h"
#include "dectalkf.h"

/***************************************************************************/
/* MVP: The following extern variables are now become elements of instance */
/* specific PH thread data structure DPH_T.                                */
/* Output of PHCLAUSE() is set of commands to SENDC()                      */
/* extern short parstochip[];   Array of output pars for frame             */
/* extern short tcum;       Current time in frames re phone begin          */
/* Used by PHDRAW(), initialized here                                      */
/* extern short durfon;     Duration in frames of current phone            */
/* extern short allophons[];   Integer rep of phonetic string              */
/* extern short allofeats[];   Structural features                         */
/* extern short allodurs[];    Duration in frames for each phone           */
/* Output of PHALLOPH()                                                    */
/* extern short nallotot;      Number of phones in phonetic string         */
/* extern short symbols[];     Integer represent of input string           */
/* extern short nsymbtot;      Number of input symbols                     */
/* extern short *user_durs;    Array of user-specified durs (optional)     */
/* extern short *user_f0;      Array of user-specified f0 (optional)       */
/* Input variables to PHCLAUSE()                                           */
/* extern short *user_offset;  Array of user-specified f0 time offsets     */
/* Output of PHSORT()                                                      */
/* extern short *phonemes;    Integer represent of real phonemes           */
/* extern short *sentstruc;   Struct feats, (mod phone[],nphonetot)        */
/* extern short nphonetot;    Number of input symbols                      */
/* Output also reordered user_durs[],user_f0[]; 						   */	
/* extern FLAG  loadspdef;    Convert curspdef[] to spdeftochip[], and     */
/* extern short curspdef[];   Speaker definition                           */
/* extern short f0tar[];      F0 target commands, in Hz*10                 */
/* extern short f0tim[];      Times between commands, in frames            */
/* Used by PHDRAWT0(), initialized here                                    */
/* Used here                                                               */
/* extern short nf0ev;      Index to current f0 command in f0tar[]         */
/* Output of PHINTON()                                                     */
/* extern short nf0tot;     Number of commands for cur clause              */
/* extern short ph_init;    Initialize program (at startup time or         */
/* after DT_STOP emergency halt) if = 0                                    */
/* Output of PHTMING()                                                     */
/* extern S32 longcumdur;   For waveform simulation printout only          */
/* extern unsigned int asperation;  lung stuff                             */
/* extern short nphone;     Index to current phone in allophons[]          */
/* extern docitation;                                                      */
/* short initpardelay=0;                                                   */
/* short far *delaypars;                                                   */
/***************************************************************************/

/* Input variables to PHCLAUSE()                                        */
/* send this speaker def array to chip if=1 */

/* Input variables used in subroutines called from here:                */
/* extern short sprate;       Nominal speaking rate in words/minute     */
/* extern short compause;     Extra pause between clauses (DELETE?)     */
/* extern short perpause;     Extra pause between sentences (DELETE?)   */

/* Used here and by PH_SETAR.C,                    */
extern short lineartilt[];  /* Linearize tilt @ 2500 Hz     */

/* static short n; *//* MVP : Moved to exit_if_done() */

/* Added function declaration for  send_pars and made static */
static void send_pars (LPTTS_HANDLE_T phTTS);
static int  exit_if_done (PDPH_T pDph_t);
static void init_pars (PDPH_T pDph_t);
static void init_clause (PDPH_T pDph_t);
void        init_phclause (PDPH_T pDph_t);
short i;

/* 
 * moved from phclause to allow syllables to be broken up after
 * allophonics ... 
 */

// Michel - Make sure to include only in your code
//          make another define as FRENCH_DEBG
//#ifdef FRENCH
//#define DEBG 1
//#endif

#ifdef DEBG // for FRENCH
void affichetab1(PDPH_T pDph_t) {
  int i;
  extern char* lognames[];

  //printf ("\n  phsort  Interrogative = %d\n\n", Interrogative);
  printf ("         phon  sent  user_ user_  ph_claus.c affichetab1() after phsort()\n");
  printf ("         emes  struc dur   f0\n");

  for (i=0; i<pDph_t->nphonetot; i++) {
    if (pDph_t->phonemes [i] & 0xFF00 == 0x1E00) {
      printf("\n");
    } else {
      printf ("%3d %2s%6x%6x%6x%6x", i, lognames [ pDph_t->phonemes [i] & 0xFF],
        pDph_t->phonemes [i], pDph_t->sentstruc [i], pDph_t->user_durs [i], 
        pDph_t->user_f0 [i]);
      if (pDph_t->sentstruc[i] & FMOT)  printf(" FMOT  ");
      if (pDph_t->sentstruc[i] & FSYNT) printf(" FSYNT ");
      if (pDph_t->sentstruc[i] & FPROP) printf(" FPROP ");
      if (pDph_t->sentstruc[i] & ACCEN) printf(" ACCEN ");
      if (pDph_t->sentstruc[i] & FGROU) printf(" FGROU ");
      if (pDph_t->sentstruc[i] & DERACC)printf(" DERACC");
      if (pDph_t->sentstruc[i] & RAISE) printf(" RAISE ");
      if ( ((pDph_t->sentstruc[i] & 0xF000) >> 12) != 0) {
        printf (" Nbc =%2d ", (pDph_t->sentstruc [i] & 0xF000) >> 12 );
      }
      printf("\n");
    }
  }
  printf ("\n\n");
} //  affichetab1

void affichetab2 (PDPH_T pDph_t) {
  int i;
  extern char* lognames[];

  //printf ("\n  phsort  Interrogative = %d\n\n", Interrogative);
  printf ("         allo  allo  user_ user_  ph_claus.c affichetab2() after phalloph()\n");
  printf ("         phons feats dur   f0\n");

  for (i=0; i<pDph_t->nphonetot; i++) {
    if (pDph_t->allophons [i] & 0xFF00 == 0x1E00) {
      printf("\n");
    } else {
      printf ("%3d %2s%6x%6x%6x%6x", i, lognames [ pDph_t->allophons [i] & 0xFF],
        pDph_t->allophons [i], pDph_t->allofeats [i], pDph_t->user_durs [i], 
        pDph_t->user_f0 [i]);
      if (pDph_t->allofeats[i] & FMOT)  printf(" FMOT  ");
      if (pDph_t->allofeats[i] & FSYNT) printf(" FSYNT ");
      if (pDph_t->allofeats[i] & FPROP) printf(" FPROP ");
      if (pDph_t->allofeats[i] & ACCEN) printf(" ACCEN ");
      if (pDph_t->allofeats[i] & FGROU) printf(" FGROU ");
      if (pDph_t->allofeats[i] & DERACC)printf(" DERACC");
      if (pDph_t->allofeats[i] & RAISE) printf(" RAISE ");
      if ( ((pDph_t->allofeats[i] & 0xF000) >> 12) != 0) {
        printf (" Nbc =%2d ", (pDph_t->allofeats [i] & 0xF000) >> 12 );
      }
      printf("\n");
    }
  }
  printf ("\n\n");
}  // affichetab2

void affichetab3 (PDPH_T pDph_t) {
  int i;
  extern char* lognames[];

  //printf ("\n  phsort  Interrogative = %d\n\n", Interrogative);
  printf ("         allo  allo  allo f0tar  ph_claus.c affichetab3()\n");
  printf ("         phons feats durs        \n");

  for (i=0; i<pDph_t->nphonetot; i++) {
    if (pDph_t->allophons [i] & 0xFF00 == 0x1E00) {
      printf("\n");
    } else {
      printf ("%3d %2s %6x %6x %6d %6d %6d", i, lognames [ pDph_t->allophons [i] & 0xFF],
        pDph_t->allophons [i], pDph_t->allofeats [i], pDph_t->allodurs [i], 
        pDph_t->f0tar [i], pDph_t->f0tim [i]);
      if (pDph_t->allofeats[i] & FMOT)  printf(" FMOT  ");
      if (pDph_t->allofeats[i] & FSYNT) printf(" FSYNT ");
      if (pDph_t->allofeats[i] & FPROP) printf(" FPROP ");
      if (pDph_t->allofeats[i] & ACCEN) printf(" ACCEN ");
      if (pDph_t->allofeats[i] & FGROU) printf(" FGROU ");
      if (pDph_t->allofeats[i] & DERACC)printf(" DERACC");
      if (pDph_t->allofeats[i] & RAISE) printf(" RAISE ");
      if ( ((pDph_t->allofeats[i] & 0xF000) >> 12) != 0) {
        printf (" Nbc =%2d ", (pDph_t->allofeats [i] & 0xF000) >> 12 );
      }
      printf("\n");
    }
  }
  printf ("----------\n"); // pb with \n\n ?
}  // affichetab3

/* to get the duration to compare with real speech */
void affichetab4 (PDPH_T pDph_t) {
  int i;
  extern char* lognames[];

  //printf ("\n  phsort  Interrogative = %d\n\n", Interrogative);

  for (i=0; i<pDph_t->nphonetot; i++) {
    if (pDph_t->allophons [i] & 0xFF00 == 0x1E00) {
      printf("\n");
    } else {
      printf ("%3d\t%2s\t%6d\t%6d\t", i, lognames [ pDph_t->allophons [i] & 0xFF],
        pDph_t->allodurs [i], (short) (pDph_t->allodurs [i]*6.4));
      printf("\n");
    }
  }
}  // affichetab4

#endif // DEBGFRENCH
 
/*
 *      Function Name: phclause()      
 *
 *  	Description: Pronounces clauses
 *
 *      Arguments: LPTTS_HANDLE_T phTTS
 *
 *      Return Value: void
 *
 *      Comments:
 *
 */

void phclause (LPTTS_HANDLE_T phTTS)
{
/* GL 04/21/1997  add this for OSF build */
#if defined  (WIN32) || defined (__osf__) || defined (__linux__)
	DT_PIPE_T   pipe_item[1];
#endif
	PKSD_T		pKsd_t = phTTS->pKernelShareData;
	PDPH_T      pDph_t = phTTS->pPHThreadData;
	
	
	/* Initialization (init variables, zero arrays) */
	init_clause (pDph_t);

	/* 
	 * 1. If speaker def changed, now it time to really change it.          
	 * The old (KL) code used to set "initsw". This gets done in the        
	 * "send_pars" routine now (it only mattered on halt).                  
	 */

	if (pDph_t->loadspdef != FALSE)
	{
		pDph_t->loadspdef = FALSE;
		setspdef (phTTS);
	}

	/*
     * for (i=0;i<pDph_t->nsymbtot;i++)
     * {
     * 	pDph_t->symbols[i] &= PVALUE;
     * 	printf("symbols[%d]=%d\n",i,pDph_t->symbols[i]);
     * }  
	 */

#ifdef DEBGFRENCH  // for FRENCH
	{ //block for i declaration
    	int i;
    	printf ("ph_claus.c  phclause() beginning\n");
    	for (i=0;i<pDph_t->nsymbtot;i++)
    	{
      		//pDph_t->symbols[i] &= PVALUE;
      		printf ("symbols[%d] = %5x %5x\n",i,pDph_t->symbols[i], pDph_t->sentstruc[i]);
    	}
    	printf ("\n\n");
  	}
#endif	// DEBGFRENCH	 

	/* 2. Sort input symbols into real phonemes vs. structural features          */
	if (phsort(phTTS) == FALSE)
		return;						   /* INPUT ARRAY:   symbols[nsymbtot]    */

	/* (optional):   user_durs[nsymbtot]  */
	/* OUTPUT ARRAYS: phonemes[nphonetot]  */
	/* sentstruc[nphonetot] */
	
	/*    
	 * for (i=0;i<pDph_t->nphonetot;i++)
	 * {
	 * 	  printf("phonemes[%d]=%d sentstruc[%d]=%d\n",i,pDph_t->phonemes[i],i,pDph_t->sentstruc[i]);
	 * }
	 */ 

#ifdef DEBGFRENCH // for FRENCH
    affichetab1 (pDph_t);
#endif 


	/* 3. Phonological rules, select allophones                             */
    /* INPUT ARRAYS: phonemes[nphonetot]    */
	phalloph (phTTS);				   
	
	/* sentstruc[nphonetot]   */
	/* OUTPUT ARRAYS: allophons[nallotot]   */
	/* allofeats[nallotot]   */

#if defined FUDD && defined ENGLISH_US
	ph_fuddify(phTTS);
#endif
	
	/*	
	 * for (i=0;i<pDph_t->nallotot;i++)
	 *	{
	 *		printf("allophons[%d]=%d allofeats[%d]=%d\n",i,pDph_t->allophons[i],i,pDph_t->allofeats[i]);
	 *		printf("user_durs[%d]=%d\n",i,pDph_t->user_durs[i]);
	 *	}
	 */

#ifdef DEBGFRENCH // for FRENCH
    affichetab2 (pDph_t);
#endif

#ifdef ENGLISH
		/* Docitation is a special flag that needs to be cleared after visiting 
		 * PHALLOPH. It is set in LTS to indicate that this word should be sited  
		 * if a single word.LTS can see the word but only ph sees the clause.    
		 */
		pDph_t->docitation = FALSE;

#endif

	/* 4. Duration rules */
    /* INPUT ARRAYS: allophons[nallotot]    */
	phtiming (phTTS);				   
	/* allofeats[nallotot] */
	/* OUTPUT ARRAY: allodurs[nallotot]     */ 
	
	// for (i=0;i<pDph_t->nallotot;i++) {
	// 	printf("allodurs[%d]=%d user_durs[%d]=%d\n",
	//          i,pDph_t->allodurs[i],i,pDph_t->user_durs[i]);
	// }

	/* 5. Fundamental frequency rules       */
    /* INPUT ARRAYS: allophons[nallotot]    */

/* GL 03/25/1998,  BATS#639 use phTTS argument instead of pDph_t */
	phinton(phTTS);

	/* allofeats[nallotot]    				*/
	/* allodurs[nallotot]     				*/
	/* OUTPUT ARRAYS: f0tim[nf0tot]         */
	/* f0tar[nf0tot]         				*/
	
	/* for (i=0;i<pDph_t->nf0tot;i++)
	 * {
	 *		printf("f0tim[%d]=%d  f0tar[%d]=%d\n",i,pDph_t->f0tim[i],i,pDph_t->f0tar[i]);
	 * }
	 */

#ifdef DEBGFRENCH // for FRENCH
    //affichetab3 (pDph_t);
    //affichetab4 (pDph_t); // for use with Excel
#endif

	/* 6. Phonetic Component (draw parameter values every 6.4 ms)           */

	init_pars (pDph_t);				   /* Initialize, routine included below   */

#ifdef GERMAN
	pDph_t->modulcount=0;
#endif

	/* For each 6.4 msec frame of current clause */
	while (TRUE)
	{
		pDph_t->oqleadtime = NF64MS;

	/*	Reset open quotient target 40 ms before start of next phone	*/
	/* (oqtarget used in PHDRAW.C, allopenq[] set in PHINTON.C)	*/

     if (pDph_t->tcum >= (pDph_t->durfon-12)) 
	 {
		pDph_t->oqtarget = pDph_t->alloopenq[pDph_t->nphone+1];
	 }
     if (pDph_t->tcum >= pDph_t->durfon) 
	 {
		pDph_t->oqtarget = 50;
	 }

		/* If time exceeds duration of current phone, Move to next one */
		if (++(pDph_t->tcum) >= pDph_t->durfon)
		{

			/* Handle index and index reply commands. */
#ifdef ENGLISH
				if (pDph_t->nphone != -1)
#endif

#ifdef SPANISH
				if (pDph_t->nphone >= 0)
#endif

#ifdef GERMAN
				if (pDph_t->nphone >= 0)
#endif

#ifdef FRENCH
				if (pDph_t->nphone != -1)
#endif

#ifdef MSDOS
					check_index (pDph_t->nphone);
#endif

/* GL 04/21/1997  add this for OSF build */
#if defined (WIN32) || defined (__osf__) || defined (__linux__)
					check_index (pKsd_t, pDph_t->nphone+1);
#endif
			pDph_t->nphone++;

			/* Graceful exit if phonemes used up */
			if (exit_if_done (pDph_t))
			{
				pDph_t->number_verbs =0 ;
				pDph_t->number_words =0; 

/* GL 04/21/1997  change this as the latest OSF code */
/* write forced clause boundary symbol to VTM */
#if defined (WIN32) || defined (__osf__) || defined (__linux__)
				pipe_item[0] = SPC_type_force;
				write_pipe (pKsd_t->vtm_pipe, pipe_item, 1);
#endif

#ifdef PH_SWAPDATA
				if (pDph_t->PHSwapOut)
				{
					fclose(pDph_t->PHSwapOut);
					pDph_t->PHSwapCnt++;
				}
#endif

				return;
			}

			/* Reset tcum to time re begin curr phone */

			pDph_t->tcum -= pDph_t->durfon;
			pDph_t->durfon = pDph_t->allodurs[pDph_t->nphone];
			//BATS 887 output from the correct place 
			//so that time aligment is correct eab 5/3/99
			pDph_t->parstochip[OUT_PH] = pDph_t->allophons[pDph_t->nphone];
			pDph_t->parstochip[OUT_DU] = pDph_t->allodurs[pDph_t->nphone];
			if (pDph_t->nphone+1 > pDph_t->nallotot)
			{
				pDph_t->parstochip[OUT_PH2] = 0;
			}
			else
				pDph_t->parstochip[OUT_PH2] = pDph_t->allophons[pDph_t->nphone+1];

			pDph_t->oqleadtime = NF40MS;
			
#ifdef ENGLISH_US
		if ((pDph_t->allophons[pDph_t->nphone] == USP_P)
		  || (pDph_t->allophons[pDph_t->nphone] == USP_T)
		  || (pDph_t->allophons[pDph_t->nphone] == USP_K)) 
		{
		    pDph_t->oqleadtime = NF20MS;	
			/* Delay until after VOT */
		}
#endif
#ifdef ENGLISH_UK
		if ((pDph_t->allophons[pDph_t->nphone] == UKP_P)
		  || (pDph_t->allophons[pDph_t->nphone] == UKP_T)
		  || (pDph_t->allophons[pDph_t->nphone] == UKP_K)) 
		{
		    pDph_t->oqleadtime = NF20MS;	
			/* Delay until after VOT */
		}
#endif


			/* Call subroutine to reset targets and trans specs (PHSETTAR.C) */

			phsettar (phTTS);
			/* INPUT ARRAYS: allophons[nallotot] */
			/* allofeats[nallotot] */
			/* allodurs[nallotot], */
			/* OUTPUT ARRAY: Parameters[]       */     
			
		} /* if (++(pDph_t->tcum) >= pDph_t->durfon) */

		/* Determine next value of f0 contour, period and TILT (PHDRAWT0.C)  */

		pht0draw (phTTS);

		/* Call draw routine to set next value for 15 control pars (PHDRAW.C) */

		phdraw (phTTS);

		/* Send pars to synthesizer (or print/save them) */

		/* debug switch GL 03/27/97 for BATS#319 */
		if (!(DT_DBG(PH_DBG,0x800)))
		send_pars (phTTS);

	} /* while(TRUE) */
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*
 *      Function Name: init_clause()      
 *
 *  	Description: Initialize variables for clause processing.
 *
 *      Arguments: PDPH_T pDph_t
 *
 *      Return Value: void
 *
 *      Comments:
 *
 */

static void init_clause (PDPH_T pDph_t)
{
	/* Initialization */
#ifdef FRENCH
	pDph_t->cbsymbol=FALSE;				/* French Interrogative off by default */
#endif

	if (pDph_t->ph_init == 0)
	{
		pDph_t->ph_init = 1;
		pDph_t->loadspdef = TRUE;	   /* Force re-init of synthesizer */
	}
	if (pDph_t->loadspdef == TRUE)
	{
		pDph_t->nf0ev = -2;			   /* Make f0 jump to initial value */
	}
	else
	{
		pDph_t->nf0ev = -1;			   /* Weak initialization  phdrawt0.c */
	}
#ifdef  PH_SWAPDATA   
	pDph_t->PHSwapIn = 0;
	pDph_t->PHSwapOut = 0;
#endif

#ifdef GERMAN
	/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
	/* initialization for sentence intonation                */
	/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
	pDph_t->old_delay = 0;
#endif
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*
 *      Function Name: init_phclause()      
 *
 *  	Description: THIS ROUTINE MUST BE CALLED BEFORE CALLING KLPARSE THE 
 *					 FIRST TIME 
 * 					 The logic of array sharing is as follows.  
 *					 (1) Input phonemes are converted to allophones in PH_ALOPH.C. 
 *					 Once converted to allophones, phonemes are not used again and
 *					 can be zapped.  The conversion process tends 
 * 					 to delete symbols, only occationally generating a new symbol.
 *					 Therefore, if one puts phonemes at the back end of the 
 *					 allophone array, no conflicts should occur.  The exact same 
 *					 argument holds for sentstruc[], user_durs[], and user_reply[].
 *					 (2) The arrays f0tar[] and f0tim[] are used in   
 * 					 PHINTON to hold f0 commands.  If user-specified f0 commands 
 *					 for SINGING, USER_SPECIFIED_F0_TARS, or USER_SPECIFIED_HATS 
 * 					 are input, they can be placed at the ends of these arrays.  
 *					 In the case of singing and F0_TARS, the commands are synched 
 * 					 with the phonemes, and the same argument as (1)   
 * 					 holds.  In the case of HATS, there is one command per ['] 
 *					 or ["] symbol in the input, and each such command results in 
 *					 the creation of 2 output commands during execution of PHINTON.  
 *					 For this case, HATS commands can be put in the back of the f0tar[],
 *					 f0tim[] arrays in every other position. 
 *
 *      Arguments: PDPH_T pDph_t
 *
 *      Return Value: 
 *
 *      Comments:
 *
 */
void init_phclause (PDPH_T pDph_t)
{
	int	i;

	for (i = 0; i < (NPHON_MAX + SAFETY + 2); i++)
	{
		pDph_t->f0tar[i] = 0;
		pDph_t->allophons[i] = 0;
		pDph_t->allofeats[i] = 0;
		pDph_t->allodurs[i] = 0;
		pDph_t->f0tim[i] = 0;

#ifdef FRENCH
		pDph_t->fconsfeats[i] = 0;
#endif

	}
	/* MVP: 03/19/96 Started adding initializing stuff here */
	pDph_t->fvvtran = 0;
	pDph_t->bvvtran = 0;

	/* Share array since fewer phonemes */
	/* Note SAFETY offset to allow a few inserts to allophons[] output string */

	pDph_t->phonemes = &(pDph_t->allophons[SAFETY]);
	pDph_t->sentstruc = &(pDph_t->allofeats[SAFETY]);
	pDph_t->user_durs = &(pDph_t->allodurs[SAFETY]);
	pDph_t->user_f0 = &(pDph_t->f0tar[SAFETY]);
	pDph_t->user_offset = &(pDph_t->f0tim[SAFETY]);

#ifdef GERMAN
	/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

	/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
	/* initializiation of special german variables           */
	/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
	pDph_t->new_sentence = TRUE;			   /* for sentence intonation */
#endif
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*
 *      Function Name: init_pars()      
 *
 *  	Description: Initializing vars. for phoneme processing.
 *
 *      Arguments: PDPH_T pDph_t
 *
 *      Return Value: 
 *
 *      Comments:
 *
 */
static void init_pars (PDPH_T pDph_t)
{
	pDph_t->tcum = -1;				   /* Time in frames relative to begin current phoneme */
	pDph_t->nphone = -1;			   /* Pointer to current phoneme */
	pDph_t->durfon = 0;				   /* Duration of current phoneme in frames */
	pDph_t->openquo = pDph_t->alloopenq[0];
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*
 *      Function Name: exit_if_done()     
 *
 *  	Description: Graceful exits if phonemes used up.
 *
 *      Arguments: PDPH_T pDph_t
 *
 *      Return Value: int
 *
 *      Comments:
 *
 */

static int exit_if_done (PDPH_T pDph_t)
{
	short n;

	if (pDph_t->nphone >= pDph_t->nallotot)
	{										/* See if done */
		/* Zero arrays whose contents must be zero upon re-entry to phclause() */
		for (n = 0; n <= pDph_t->nsymbtot; n++)
		{
			pDph_t->user_durs[n] = 0;
			pDph_t->user_f0[n] = 0;
			pDph_t->user_offset[n] = 0;
		}
   
#ifdef GERMAN
		if ((pDph_t->allofeats[pDph_t->nallotot - 1] & FPERNEXT) != 0)
		{
			pDph_t->new_sentence = TRUE;
		}
		else
		{
			pDph_t->new_sentence = FALSE;
		}
#endif		
		return (TRUE);
	}
	return (FALSE);
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*
 *      Function Name: send_pars()     
 *
 *  	Description: Moves frames into the output buffer and
 *					 sends the output buffer.
 *
 *      Arguments: LPTTS_HANDLE_T phTTS
 *
 *      Return Value: void
 *
 *      Comments:
 *
 */

static void send_pars (LPTTS_HANDLE_T phTTS)
{

	int                     asp_bump = 0;
	PKSD_T                  pKsd_t = phTTS->pKernelShareData;
	PDPH_T                  pDph_t = phTTS->pPHThreadData;

	/* Special buffer to delay all pars except AV, TILT, & T0 by one frame */
	/* 1. Move non-delayed pars to output buffer.        				   */
	/* 2. Send output buffer.                                    		   */
	/* 3. Move delayed pars to output buffer.                    		   */

	if (pDph_t->initpardelay == 0)
	{
		pDph_t->initpardelay++;
#ifdef SEPARATE_PROCESSES
		pDph_t->delaypars = (short *) calloc (sizeof (short), VOICE_PARS);
#else
		pDph_t->delaypars = (short _far *) spcget (SPC_type_voice);
#endif
	}
	else
	{
		if ( (pDph_t->delaypars[OUT_AV] = pDph_t->parstochip[OUT_AV]) )
			asp_bump = TRUE;
		/* 
		 * Linearize the actual tilt to be more like the requested tilt
		 */
		/* restore lineartilt even though we limit check now eab 7/15/98 BATS 715*/

#ifdef FRENCH
       pDph_t->delaypars[OUT_TLT] = pDph_t->parstochip[OUT_TLT];
       //printf("ph_claus.c  parstochip[OUT_TLT] %d, delaypars[OUT_TLT] %d\n", 
       //     pDph_t->parstochip[OUT_TLT], pDph_t->delaypars[OUT_TLT]);
#else
#ifndef  NEW_TILT
		pDph_t->delaypars[OUT_TLT] = lineartilt[pDph_t->parstochip[OUT_TLT]];
		if(pDph_t->delaypars[OUT_TLT] <12)
			pDph_t->delaypars[OUT_TLT]=12;
#else
		pDph_t->delaypars[OUT_TLT] = pDph_t->parstochip[OUT_TLT];
#endif	// NEW_TILT
#endif	// FRENCH

	  //printf("tiltin %d tilt out %d\n", pDph_t->parstochip[OUT_TLT],pDph_t->delaypars[OUT_TLT]);


		pDph_t->delaypars[OUT_T0] = pDph_t->parstochip[OUT_T0];

		/* Panic halt. Kill off this clause. The SPC handler notes that
		 * the "halting" is non 0, and discards packets. 
        */

		if (pKsd_t->halting)
		{
			pDph_t->tcum = pDph_t->durfon;	/* Clobber the clause.  */
			pDph_t->nphone = pDph_t->nallotot;
			pDph_t->ph_init = 0;	   /* May be heavy-handed. */
			return;
		}

		/* Send frame of output parameters to synthesizer chip (in PH_CLAUS.C) */

#ifdef SEPARATE_PROCESSES
		fwrite (&vc, sizeof (short), 1, stdout);
		fwrite (pDph_t->delaypars, sizeof (short), VOICE_PARS, stdout);

		fflush (stdout);
#else
#ifdef MSDOS
		spcwrite (pDph_t->delaypars);
#endif

/* GL 04/21/1997  add this for OSF build */
#if defined (WIN32) || defined (__osf__) || defined (__linux__)

#if 0 //DEBG // for FRENCH
          /*  printf("\n   AH   F1   A2   A3   A4   A5   A6   AB  TLT   F0   AV   F2   F3   FZ   B1   B2   B3\n"); */
          printf ("%3s ", phprint (pDph_t->pSTphsettar->phcur) );
          printf ("%2d ", pDph_t->delaypars [0]);
          printf ("%4d ", pDph_t->delaypars [1]);
          for(i=2; i<=8; i++) printf ("%2d ", pDph_t->delaypars [i]);
          printf ("%4d ", pDph_t->delaypars [9]);
          printf ("%2d ", pDph_t->delaypars [10]);
          printf ("%3d ", pDph_t->delaypars [11]);
          printf ("%3d ", pDph_t->delaypars [12]);
          for(i=13; i<17; i++) printf ("%3d ", pDph_t->delaypars [i]);
          printf ("\n");
#endif	// 0
		spcwrite (pKsd_t, pDph_t->delaypars);
#endif // defined (WIN32) || defined (__osf__) || defined (__linux__)
		pDph_t->delaypars = (short far *) spcget (SPC_type_voice);
#endif	// SEPARTE_PROCESSES
	}
	pDph_t->delaypars[OUT_F1] = pDph_t->parstochip[OUT_F1];
	pDph_t->delaypars[OUT_B1] = pDph_t->parstochip[OUT_B1];
	pDph_t->delaypars[OUT_F2] = pDph_t->parstochip[OUT_F2];
	pDph_t->delaypars[OUT_B2] = pDph_t->parstochip[OUT_B2];
	pDph_t->delaypars[OUT_F3] = pDph_t->parstochip[OUT_F3];
	pDph_t->delaypars[OUT_B3] = pDph_t->parstochip[OUT_B3];
	pDph_t->delaypars[OUT_FZ] = pDph_t->parstochip[OUT_FZ];
	if ( (pDph_t->delaypars[OUT_A2] = pDph_t->parstochip[OUT_A2]) )
		asp_bump = TRUE;
	if ( (pDph_t->delaypars[OUT_A3] = pDph_t->parstochip[OUT_A3]) )
		asp_bump = TRUE;
	if ( (pDph_t->delaypars[OUT_A4] = pDph_t->parstochip[OUT_A4]) )
		asp_bump = TRUE;
	if ( (pDph_t->delaypars[OUT_A5] = pDph_t->parstochip[OUT_A5]) )
		asp_bump = TRUE;
	if ( (pDph_t->delaypars[OUT_A6] = pDph_t->parstochip[OUT_A6]) )
		asp_bump = TRUE;
	if ( (pDph_t->delaypars[OUT_AB] = pDph_t->parstochip[OUT_AB]) )
		asp_bump = TRUE;

#ifndef FRENCH
	if(pDph_t->parstochip[OUT_AP] >=10)
			pDph_t->delaypars[OUT_AP] = pDph_t->parstochip[OUT_AP]-3;
#endif
	pDph_t->delaypars[OUT_AP] = pDph_t->parstochip[OUT_AP];

/* GL 04/21/1997  add this for OSF build */
#if defined (WIN32) || defined (__osf__) || defined (__linux__)
	pDph_t->delaypars[OUT_PH] = pDph_t->parstochip[OUT_PH];
	pDph_t->delaypars[OUT_DU] = pDph_t->parstochip[OUT_DU];
	pDph_t->delaypars[OUT_PH2] = pDph_t->parstochip[OUT_PH2];
	
#endif

#ifdef NEW_VTM
		pDph_t->delaypars[OUT_FNP] = pDph_t->parstochip[OUT_FNP];
		pDph_t->delaypars[OUT_GS] = pDph_t->parstochip[OUT_GS];
		pDph_t->delaypars[OUT_OQ] = pDph_t->parstochip[OUT_OQ];
		pDph_t->delaypars[OUT_BR] = pDph_t->parstochip[OUT_BR];
#endif
	/* add to asperation if there is sound. */

#ifdef ENGLISH
	pDph_t->asperation += asp_bump;
#endif

}

int ph_fuddify(LPTTS_HANDLE_T phTTS)
{
	PDPH_T pDph_t = phTTS->pPHThreadData;
	int i=0;
	do {
		switch (pDph_t->allophons[i])
		{
			case USP_R: case USP_LL:
				pDph_t->allophons[i] = USP_W;
				break;
			case USP_RR:
				pDph_t->allophons[i] = USP_UH;
				break;
			case USP_EL:
				pDph_t->allophons[i] = USP_OW;
				break;
			case USP_ER: /* very */
				pDph_t->allophons[i] = USP_EH; /* really should go to USP_EH USP_W */
				break;
		}
	} while (pDph_t->allophons[++i]!=0);
	return 1;
}
/*********************************end of phclause.c**************************/