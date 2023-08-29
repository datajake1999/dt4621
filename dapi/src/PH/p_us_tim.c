/* 
 ***********************************************************************
 *
 *                           Copyright �
 *	  Copyright � 2000-2001 Force Computers, Inc., a Solectron Company. All rights reserved.
 *    � Digital Equipment Corporation 1996, 1997. All rights reserved.
 *
 *    Restricted Rights: Use, duplication, or disclosure by the U.S.
 *    Government is subject to restrictions as set forth in subparagraph
 *    (c) (1) (ii) of DFARS 252.227-7013, or in FAR 52.227-19, or in FAR
 *    52.227-14 Alt. III, as applicable.
 *
 *    This software is proprietary to and embodies the confidential
 *    technology of Force Computers Incorporated and other parties.
 *    Possession, use, or copying of this software and media is authorized
 *    only pursuant to a valid written license from Force or an
 *    authorized sublicensor.
 *
 ***********************************************************************
 *    Revision History:
 *
 * Rev  Who     Date            Description
 * ---  -----   -----------     --------------------------------------------
 * 0001 DK 		09/01/1984      Initial creation
 * 0002 DGC		12/27/1984	    Modified for the 80186.
 * 0003 DGC		01/02/1985    	Added some conditional calls to the "mstofr"
 *          					routine. Some of the conversions from MS to
 *          					frames caused overflow on 16 bit machines.
 * 0004 DK		02/26/1985 	    [nt] cluster too long
 * 0005 DK		03/18/1985    	period pause and comma pause code had a bug
 * 0006 DK		03/25/1985     	Let phrase-final lengthening apply to word before prep
 * 0007 DK		04/17/1985	    Reduce compound shortening and short-word lengthening
 * 0008 DK 		04/23/1985	    Word-final fricatives longer
 * 0009 DK 		04/25/1985	    Final lengthing before preposition only at slow sprate
 * 0010 DK		05/15/1985	    Fix [nt] cluster reduction to happen only at word end
 * 0011 DK		05/17/1985	    Make word-init stressed vowels longer, final ptk shorter
 * 0012 DK		05/23/1985	    Word-initial vowels not quite so short, less vowel
 *           					lengthening induced by postvoc voiced fric
 * 0013 DK		06/20/1985      Fix nasal durs for "pense,pen,pend"
 * 0014 EAB		06/16/1990	    Allow speaking rate to 550 word per min. (from 350)
 * 0015 EAB		07/25/1990     	ADDED CHANGE TO ALLOW VARIABLE SETTING OF COMMA PAUSE
 *          					FOR NANCY JARRELL OF CHB TO GET IT TO ZERO. NOTE
 *          					-300 SETTING OF COMPAUSE ALLOWS SETTING TO ZERO BUT
 *          					THE CODE HAS NOT BEEN CHECKED FOR ERRORS.
 *
 *              DURATION RULES
 * 0016 EAB		05/03/1993      ADDED NEW PHONE DF TO DIFFERENTIATE T FROM D FLAP
 *                             	and added rules to make use of it.
 * 0017 EAB 	05/02/1993      restrucutred a bunch of stuff-reduced 
 *                              
 * 0018 EAB		05/02/1993      ADDED PETROCELLI'S NEW DURATION RULES.
 * 0019 MGS		03/25/1996      Merged win 95 code to 42c
 * 0020 MGS 	04/01/1996      Added MSDBG statements for debugging
 * 0021 MGS 	04/02/1996      made sure all local variable are initialized
 * 0022 MGS		06/06/1996	 	moved phtiming here.
 * 0023 SIK		07/12/1996  	Cleaning up and maintenance
 * 0024 GL		10/30/1996		merge the change from V43 code base.
 * 0025	GL		04/21/1997		BATS#360  remove spaces before "#define" or "#if" 
 * 0026	MGS		08/26/1997		Merged in fasttalk
 * 0027 EAB		09/08/97		Added in changes to improve fastalk typing and SLOWSPEAK
 * 0028 EAB     10/12/07		Removed Obsolete prphdurs and prdurs bats 495(performance)
 *								And improved typing_mode
 * 0029 EAB		4/4/98		    Found problem where stess was modifying aspiration as well as av because it was in
 *							    the wrong place. This had potential of causing other nasty problems. 
 * 0030 EAB		7/13/98		    Found redundant tcumdur code that was not needed. It's calculated
 *							    in phinton1/2 now.BATS 713 tcumdur addition removed
 * 0031 eab		7/22/98		    Modified duration rules to support all levels of reduction on a monosylable
 * 0032 EAB		8/17/98 	    Refinfed and added some rules for ENGLISH DECTALK
 * 0033 EAB		9/11/98 	    Refinfed and added some rules for ENGLISH DECTALK (ditto)
 * 0034 EAB     2/3/99			Improved some rules that were compounded to too strong an effct in some place
								Changed vowcnt to sonocnt becuase we're now wounting sonorants
								did further tuning to improve stressed timed rythm
 * 0035 EAB     5/26/99			BATS 894 Inter vocalic the are no longer flapped for better articualtion but
								the timing rule of American English still needs to fire.
 * 0036 EAB		7/9/99			BATS 905 and 906 for NWS_NOAA
 * 0037 EAB     4/17/00         Tuned some paramters for 4.6 release
 * 0037	MGS		04/13/2000		Changes for integrated phoneme set 
 * 0038 NAL		04/18/00		Change for integrated phoneme set
 * 0064 CAB	    10/18/2000	    Changed copyright info
 * 0065 eab						Modified to support fduration modification by part of speech.
 * 0066 EAB 					Minor chnage to inmrpove behavior...
 * 0067 cab		03/16/2001		Update copyright info
 * 0068 EAB bats 943 discrimation of p's d's etc. 
 */ 

 
/*
 *      Function Name: phtiming()      
 *
 *  	Description: 
 *
 *      Arguments: LPTTS_HANDLE_T phTTS
 *
 *      Return Value: void
 *
 *      Comments:
 *
 */

//#define DEBUGPHT
//#define FASTTALK
extern __inline short phone_feature(PDPH_T pDph_t, int phone);	   /* Phonetic features            */
extern int inh_timing(LPTTS_HANDLE_T phTTS, int phone);
extern int min_timing(LPTTS_HANDLE_T phTTS, int phone);

void phtiming (LPTTS_HANDLE_T phTTS)
{
	short                   psonsw = 0, posvoc = 0;
	PDPH_T                  pDph_t = phTTS->pPHThreadData;
	PKSD_T                  pKsd_t = phTTS->pKernelShareData;
	PDPHSETTAR_ST           pDphsettar = pDph_t->pSTphsettar;

	short                   stcnt = 0;
	short                   syldur = 0;
	short                   ncnt = 0;
	short                   endcnt = 0;
	short					sonocnt = 0;
	short                   adjust = 0;
	short                   emphasissw = FALSE;		/* Made local and initialized */
	short                   pholas = GEN_SIL;	/* Made local and initialized */
	short                   struclas = 0;	/* Made local and initialized */
	short                   fealas = GEN_SIL;	/* Made local and initialized */
	short                   prcnt = 0, durinh = 0, durmin = 0, deldur = 0, nphon = 0;
	short                   phocur = 0, feacur = 0, feasyllabiccur = 0;
	short                   struccur = 0, strucboucur = 0, strucstresscur = 0;
	short                   dpause = 0;
	short					arg1,arg2;	/* arguments for the phmath routines. */
#ifdef NEWTYPING_MODE
	short					numbersonor;
#endif
#ifdef TYPING_MODE
	short					minsize;
#endif
	U32  wordfeat;

	/* Initialization  (Set sprat1, sprat2, zero counters, print debug) */

	init_timing (phTTS);


	pDph_t->tcumdur =0;/* 9/97EAB Since durations are done differently 
					   in typing mode calculation
					   of total dur must be moved to here also
						NOTE TO CARL THIS MAY HAVE ALREADY BEEN SUBMITTED BY DOUG*/
#ifdef NEWTYPING_MODE
	numbersonor=0;
	for (nphon = 0; nphon < pDph_t->nallotot; nphon++)
	{
		feacur=phone_feature( pDph_t ,pDph_t->allophons[nphon]);
		if((feacur & FSONOR) IS_PLUS && pDph_t->allophons[nphon] != GEN_SIL)
			numbersonor +=1;
	}
#endif

	/* MAIN LOOP, for each output phoneme */
//helpme
	//	for (nphon = 0; nphon < pDph_t->nallotot; nphon++)
	//	{
	//		pDph_t->allophons[nphon]=(pDph_t->allophons[nphon] & PVALUE);
	//	}
	for (nphon = 0; nphon < pDph_t->nallotot; nphon++)
	{
		if (nphon > 0)
		{
			pholas = pDph_t->allophons[nphon - 1];
			struclas = pDph_t->allofeats[nphon - 1];
			fealas = phone_feature(pDph_t ,pholas);
		}

		phocur = pDph_t->allophons[nphon];
		struccur = pDph_t->allofeats[nphon];
		strucboucur = struccur & FBOUNDARY;
		feacur = phone_feature( pDph_t ,phocur);
		feasyllabiccur = feacur & FSYLL;
		strucstresscur = struccur & FSTRESS;

		if (nphon < (pDph_t->nallotot - 1))
		{
			pDphsettar->phonex_timing = pDph_t->allophons[nphon + 1];
			pDphsettar->strucnex = pDph_t->allofeats[nphon + 1];
			pDphsettar->feanex = phone_feature( pDph_t ,pDphsettar->phonex_timing);
		}		

		wordfeat = pDph_t->allofeats[nphon] & WORDFEAT;
		if(wordfeat)
		{
			if(wordfeat & F_NOUN)
			{
				wordfeat = N120PRCNT;
			}
			else if(wordfeat & F_ADJ)
			{
				wordfeat = N100PRCNT;

			}
			else if(wordfeat & F_VERB)
			{
				wordfeat = N50PRCNT;
			}
			else if(wordfeat & F_FUNC) //already gets crushed so don't do much now
				//perhaps later
			{
				wordfeat = N100PRCNT;
			}
			else
				wordfeat =N100PRCNT; //If not sure don't do anything

		}
		else

			wordfeat=N100PRCNT;





		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		/* Duration Rules                         						   */
		/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
		/* Use user-specified duration if one exists.         */
		/* User durations can be huge; call the conversion routine.   */
		if (pDph_t->user_durs[nphon] != 0)
		{
			pDphsettar->durxx = mstofr(pDph_t->user_durs[nphon] + 4);
#ifdef MSDBG5
			printf ("durxx = mstofr(user_durs[nphon]+4) durxx=%d\n", pDphsettar->durxx);
#endif

#ifdef DEBUG_USER_PROSODICS
			printf ("\tFound user_dur[%s] = %3d frames in PHTIMING\n",
					phprint (phocur), pDphsettar->durxx);
#endif

			goto break3;
		}

		/* Convert inherent and minimum duration in msec to frames.*/
		/* Fixed overflow in 16 bits is not possible on these ones.*/
		
		durinh = ((inh_timing(phTTS,phocur) * 10) + 50) >> 6;
		durmin = ((min_timing(phTTS,phocur) * 10) + 50) >> 6;


		/* Additive increment */
		deldur = 0;
		/* Multiplicative constant (let 128 be 100%) */
		prcnt = 128;

				//Adjust word length by part of speech
		if(wordfeat)
			{
				arg1=wordfeat;
				arg2=prcnt;
				prcnt = mlsh1 (arg1, arg2);
			}		

		

		/* 
		 * Rule 1: Pause durations depend on syntax
		 *          Clause-initial pause should be minimal, i.e. NF64MS (enough
		 *          time for initial fricative to build up amp gradually)
		 *          Shortened to 0, except for fricitive and plosive in next phone
		 *          we go do 7 ...
		 */
		if (phocur == GEN_SIL)
		{
			if (((pDphsettar->feanex & FVOICD) && (pDphsettar->feanex & FOBST)) || (pDphsettar->feanex & FPLOSV))
				/* GL 10/30/1996, merge the change from V43 code base */
				/* dpause = NF7MS; */
				dpause = 4;
			else
				/* dpause = 0;     */
				dpause = 5;

			pDph_t->asperation = (pDph_t->asperation - BASE_ASP) / 10;

			/* Treatment of other than clause-initial pauses: */
			if (nphon > 1)
			{
				/* If this clause ends in a comma, use short pause */
				/* Note extra compause added if user command [:dv cp __] */
				if ((struclas & FBOUNDARY) == FCBNEXT)
				{
#ifdef MSDEBUG
					printf ("asperation 1111 asperation=%d\n", pDph_t->asperation);
#endif

					if (pDph_t->asperation > MAX_ASP_COMMA)
						pDph_t->asperation = MAX_ASP_COMMA;
					else if (pDph_t->asperation < MIN_ASP_COMMA);

					pDph_t->asperation = MIN_ASP_COMMA;
#ifdef MSDEBUG
					printf ("asperation is now screwed up 1111\n");
#endif
					dpause = NF_COMMA + pDph_t->compause + pDph_t->asperation;
				}
				/* End of clause has long pause if ends with "." "!" or "?" */
				/* Note extra perpause added if user command [:dv pp __] */
				if (((struclas & FBOUNDARY) & FSENTENDS) IS_PLUS)
				{
#ifdef MSDEBUG
					printf ("asperation 2222 asperation=%d\n", pDph_t->asperation);
#endif
					if (pDph_t->asperation > MAX_ASP_PERIOD)
						pDph_t->asperation = MAX_ASP_PERIOD;
					else if (pDph_t->asperation < MIN_ASP_PERIOD);
					pDph_t->asperation = MIN_ASP_PERIOD;
#ifdef MSDEBUG
					printf ("asperation is now screwed up 2222\n");
#endif
					dpause = NF_PERIOD + pDph_t->perpause + pDph_t->asperation;
				}

			}
			/* Make sentence-initial pause long if this is a new paragraph */
			else if (pDph_t->newparagsw != FALSE)
			{
				dpause = NF_PERIOD;
			}
			pDph_t->asperation = 0;

			/* Effect of speaking rate greatest on pauses */

			arg1 = dpause;
			arg2 = pDphsettar->sprat1;
			dpause = mlsh1 (arg1, arg2);
			/* Minimum pause is NF64MS */
			/* EDIT 7/25/90-EAB CHNAGED MINUMUM FROM 64MS TO 7MS AND ADDED MAGIC */
			/* NUMBER COMAPAUSE TO SET IT TO 0 FOR TESTING */
			if (dpause < NF7MS)
				dpause = NF7MS;

			/* Skip over remaining duration rules if input is SIL */

			pDphsettar->durxx = dpause;
#ifdef MSDBG5
			printf ("durxx = dpause durxx=%d\n", pDphsettar->durxx);
#endif

			durinh = pDphsettar->durxx;		/* for debugging print only */
			durmin = pDphsettar->durxx;
			
			goto break3;
		}
		/* Rule 2: Lengthening of segments in clause-final rime */
		if (strucboucur >= FCBNEXT)
		{
			deldur = NF40MS;
			/* Except for plosives and voiced fricatives */
			if (((feacur & FVOICD) IS_PLUS)
				&& ((feacur & FOBST) IS_PLUS))
			{
				deldur = NF20MS;
			}
			if ((feacur & FPLOSV) IS_PLUS)
				{
					deldur = 0;
				}
			/* Except for sonor conson [rx, lx] followed by voiceless obst */
			if (((phocur == USP_RX) || (phocur == USP_LX))
				&& ((pDphsettar->feanex & FOBST) IS_PLUS)
				&& ((pDphsettar->feanex & FVOICD) IS_MINUS))
				{
					deldur = NF15MS;
				}
			/* More lengthening of a vowel if in a short phrase */
			if ((pDph_t->nallotot < 10)
				&& (feasyllabiccur IS_PLUS)
				&& (strucstresscur IS_PLUS))
				{
					deldur += (NF30MS - (pDph_t->nallotot >> 1));
				}
			/* Less lengthening if next seg is sonorant in same rime */
			if ((pDphsettar->feanex & FSON1) IS_PLUS)
				{
					deldur -= NF20MS;
				}
			
		}
		/* Rule 3: Shortening of non-phrase-final syllabics (pp counted as phrase only at slow speaking rates) */
		if (feasyllabiccur IS_PLUS)
		{
			if (((strucboucur < FVPNEXT) && (pKsd_t->sprate > 160))
				|| (strucboucur < FPPNEXT))
			{
#ifndef NWS_US

			/* eab 7/9/99 EAB FOr NWS words before things like "northwest at 10 mph" northwest should not be 
			reduced	as they are "important words" BATS 905 and 906 The at is the phrase marker causing the reduction*/
				/* Reduce percent by factor of 0.7 */

				arg1 =  N70PRCNT;
				arg2 =  prcnt;
				prcnt = mlsh1 (arg1, arg2);

#endif
				
				
			}
		}

		/* Lengthening of phrase-final postvocalic nasal */
		/* 
		 * OUT
		 * else { if (((feacur & FNASAL) IS_PLUS) && (strucstresscur IS_MINUS) && 
		 * (strucboucur >= FVPNEXT)) { deldur = deldur + NF20MS;
		 * prdurs(pDph_t,phocur,durinh,durmin,deldur,prcnt,3); } } 
		 * END OUT 
		 */

		/* Rule 4: Shorten syll segs in syll-init and medial positions, */
		/* and in unstressed monosyllables  eab 7/22/98 Modify to shorten
		stressed monosyllables as well just not as much. The old code supported secondary stress
		reduction but the rest of the code never really supported secondary stress until recently*/
		if (feasyllabiccur IS_PLUS)
		{
			if((struccur & FTYPESYL) == FMONOSYL)
			{
				arg1 = N90PRCNT;
				if ((strucstresscur & FSTRESS_1) IS_MINUS)
				{
					/* Secondary - stressed monosyllables shortened by 85% */
					arg1 = N85PRCNT;

				if (strucstresscur IS_MINUS)
				{
					/*Unstressed monosyllable shorted by 70% */

					arg1 = N70PRCNT;
				}
				arg2 = prcnt;
				prcnt = mlsh1(arg1, arg2);
				
				}
			}
			else if (((struccur & FTYPESYL) != FMONOSYL)
					 && (strucboucur < FWBNEXT))
			{
				/* Initial vowel of each word is shorter by .85 (was 0.7) */
				arg1 = N85PRCNT;

				if ((struccur & FTYPESYL) > FFIRSTSYL)
				{
					/* Other nonfinal syllables shortened by 0.85 */

					arg1 = N85PRCNT;
				}
				arg2 = prcnt;
				prcnt = mlsh1 (arg1, arg2);
				/* Stressed vowels are more compressible if in nonfinal syll */
				/* OUT
				 * if (strucstresscur IS_PLUS) { durmin -= (durmin>>2); }                  
				 * END OUT 
				 */
				
			}
			/* break1: *//* MVP :Never used this label commented out */

			/* Rule 5: Shorten vowels in polysyllabic words */
			if ((struccur & FTYPESYL) != FMONOSYL)
			{
				/* Multiply by 0.8 */

				arg1 = prcnt;
				arg2 = N80PRCNT;
				prcnt = mlsh1 (arg1, arg2);
				
			}
		}
		/* Rule 6: Shortening of non-word-initial consonants */
		if ((feasyllabiccur IS_MINUS) && ((struccur & FWINITC) IS_MINUS))
		{
			if (((feacur & FOBST) IS_PLUS)
				&& ((feacur & FPLOSV) IS_MINUS)
				&& ((struccur & FBOUNDARY) == FWBNEXT))
			{
				/* Except that word-final fricatives are lengthened */
				deldur += NF20MS;
			}
			else
			{
				/* Multiply by 0.85 */
				arg1 = prcnt;
				arg2 = N85PRCNT;
				prcnt = mlsh1 (arg1, arg2);

			}
			
		}
		/* Rule 7: Shortening of unstressed segs */
		if ((strucstresscur & FSTRESS_1) IS_MINUS)
		{
			if ((durmin < durinh) && ((feacur & FOBST) IS_MINUS))
			{
				/* Non-stressed segs more compressible (except obstruents) */
				if (strucstresscur IS_MINUS)
				{
					durmin = durmin >> 1;
				}
				else
				{
					durmin -= (durmin >> 2);	/* 2-stress */
				}
			}
			/* Non-primary-stressed syllabic segments shorter */
			if (feasyllabiccur IS_PLUS)
			{
				/* Shorten word - medial syllable more */
				if ((struccur & FTYPESYL) == FMEDIALSYL)
				{

					prcnt = prcnt >> 1;
				}
				else
				{
					/* Multiply by 0.7 */

					arg1 = prcnt;
					arg2 = N70PRCNT;
					prcnt = mlsh1 (arg1, arg2);
				}
				/* Special case: Schwa next to a flap or followed by HX */
				if ((phocur == USP_AX) || (phocur == USP_IX))
				{
					if ((pholas == USP_DX) || (pDphsettar->phonex_timing == USP_DX) || (pDphsettar->phonex_timing == USP_HX))
					{
						deldur += NF15MS;
					}
				}
			}
			else
			{
				/* Extra shortening of w,y,r,l */
				if ((phocur >= USP_W) && (phocur <= USP_LL))
				{
					prcnt = prcnt >> 1;
				}
				else
				{
					/* All other consonants */
					/* Multiply by 0.7 */

					arg1 = prcnt;
					arg2 = N70PRCNT;
					prcnt = mlsh1 (arg1, arg2);
				}
			}
			
		}
		/* Penultimate lengthening of stressed syllabic if hat fall f0 gesture */
		else
		{
			if (feasyllabiccur IS_PLUS)
			{
				if (((struccur & FHAT_ENDS) IS_PLUS)
					&& (strucboucur < FVPNEXT)
					&& (strucboucur > FMBNEXT))
				{
					deldur = deldur + NF25MS;
					
				}
			}
		}
		/* Rule 8: Lengthen each seg of an emphasized syllable, including rime */
		if (((struccur & FWINITC) IS_PLUS)
			|| ((feasyllabiccur IS_PLUS) && (strucstresscur != FEMPHASIS)))
		{
			emphasissw = FALSE;
		}
		if (strucstresscur == FEMPHASIS)
		{
			emphasissw = TRUE;
		}
		if (emphasissw == TRUE)
		{
			deldur = deldur + NF20MS;
			if (feasyllabiccur IS_PLUS)
				deldur = deldur + NF40MS;
			
		}
		/* Rule 9: Influence of final conson on vowels and postvoc sonor */
		/* Switch to indicate presence of a postvocalic sonorant */
		psonsw = 0;					   /* Set to 1 if +syl is followed by sonor */
		arg1 = FRAC_ONE;	   /* Default if posvoc not obst */
		posvoc = GEN_SIL;				   /* Default postvocalic consonant */
		/* Does rule apply ? */

		if ((feasyllabiccur IS_PLUS)
			|| ((phocur >= USP_RX) && (phocur <= USP_NX)
				&& ((struccur & (FSTRESS | FWINITC)) IS_MINUS)
				&& ((pDphsettar->feanex & FOBST) IS_PLUS)))
		{
			/* Determine whether next segment is postvocalic consonant */
			if (((pDphsettar->feanex & FSYLL) IS_MINUS)
				&& ((pDphsettar->strucnex & (FSTRESS | FWINITC)) IS_MINUS))
			{
				posvoc = pDphsettar->phonex_timing;
				/* See if postvocalic consonant is a sonorant */
				/* or if postvoc sonor is followed by an obst cons */
				if (((posvoc >= USP_RX) && (posvoc <= USP_NX))
					&& ((phone_feature( pDph_t ,pDph_t->allophons[nphon + 2]) & FOBST) IS_PLUS)
					&& ((pDph_t->allofeats[nphon + 2] & (FSTRESS | FWINITC)) IS_MINUS))
				{
					psonsw = 1;
					posvoc = pDph_t->allophons[nphon + 2];
				}
				/* If posvoc is now voicless or obst or nasal, do something */
				if (posvoc != GEN_SIL)
				{
					if ((phone_feature( pDph_t ,posvoc) & FVOICD) IS_MINUS)
					{
						deldur = deldur - (deldur >> 1);
						/* Multiply by 0.8 if a voiceless fric */

						arg1 = N80PRCNT;
						if (((phone_feature( pDph_t ,posvoc) & FPLOSV) IS_PLUS)
							|| (posvoc == USP_CH))
						{
							/* Multiply by 0.7 if a voiceless plosive */

							arg1 = N70PRCNT;
						}
#ifdef NEVER_USED // EAB Found the reason it was commented out
						//was that it was redundant to rule 4 and was coded incorrectly
						if ((strucstresscur == FSTRESS_1) &&
							((phocur != USP_AE) || ((struccur & FTYPESYL) == FMONOSYL)))
						{
							pDph_t->allofeats[nphon] = pDph_t->allofeats[nphon] & (!FSTRESS_1);

							arg2 = prcnt;
							arg1 = N50PRCNT;
							/* this was commented out why?*/
							 prcnt = mlsh1(arg1,arg2); 
						}
#endif
					}
					/* Postvocalic segment is voiced */
					else
					{

						/* Assume voiced plosive, multiply by 1.2 */
						/*EAB found that this rule lenghthened syallbic n by
						too much in final position 11/13/97 This I left in
						because it is very specific and safe */
						if ((phone_feature( pDph_t ,posvoc) & FOBST) IS_PLUS && phocur != USP_EN)
						{

							arg1 = N120PRCNT;
							/* Voiced fricative, add 25 ms to +syl */
							if (((phone_feature( pDph_t ,posvoc) & FPLOSV) IS_MINUS)
							/* OUT                && (strucboucur >= FVPNEXT)   END OUT */
								&& (posvoc != USP_DX)
								&& ((feacur & FSYLL) IS_PLUS))
							{
								deldur = deldur + NF25MS;
							}

						}
						/* Nasal, multiply by 0.85 */
						else if ((phone_feature( pDph_t ,posvoc) & FNASAL) IS_PLUS)
						{

							arg1 = N85PRCNT;
						}
					}
				}
			}
			/* Attenuate effect if not phrase-final or +syl followed by sonor */
			/* or if postvoc sonor next */
			if ((strucboucur < FVPNEXT) || (psonsw == 1))
			{
				arg1 = FRAC_HALF + (arg1 >> 1);
			}
			/* Multiply by 0.1 if [nt] is  postvocalic cluster (T nonwordinit) */
			if (((phocur == USP_N) && (pDphsettar->phonex_timing == USP_T))
				&& ((pDphsettar->strucnex & (FWINITC | FSTRESS)) IS_MINUS))
			{

				arg1 = N10PRCNT;
				if (((phone_feature( pDph_t ,pDph_t->allophons[nphon + 2]) & FSYLL) IS_PLUS)
					&& ((pDph_t->allofeats[nphon + 2] & FMEDIALSYL) IS_MINUS))
				{
					pDph_t->allophons[nphon + 1] = USP_D;	/* Change to [d] after durs */

					arg1 = N70PRCNT;
				}
			}
			if(arg1 <500)
				arg1=4196;
			arg2 = prcnt;
			prcnt = mlsh1 (arg1, arg2);
			if (arg1 != FRAC_ONE);
				
		}
		/* Rule 10: Lengthen first vowel of a two vowel sequence */
		if (feasyllabiccur IS_PLUS)
		{
			if ((pDphsettar->feanex & FSYLL) IS_PLUS)
			{
				deldur = deldur + NF30MS;
				
			}
			/* Rule 11: Lengthen word-initial stressed vowel of polysyllabic word */
			if (((struccur & FTYPESYL) == FFIRSTSYL)
				&& ((struccur & FSTRESS_1) IS_PLUS)
				&& ((struclas & FWINITC) IS_MINUS))
			{
				deldur += NF25MS;
				
			}
			/* Rule 12: Shorten vowels before postvocalic L */
			if (pDphsettar->phonex_timing == USP_LX)
			{
				/* rule not strong enough eab 9/3/98*/
				deldur -= NF20MS;
					/* Reduce percent by factor of 0.7 */
				arg1 = N40PRCNT;
				arg2 = prcnt;
				prcnt = mlsh1 (arg1, arg2);
				
				
			}
		}
		/* Rule 13: Shorten consonant clusters */
		else
		{
			if ((feacur & FCONSON) IS_PLUS)
			{
				if (((pDphsettar->feanex & FCONSON) IS_PLUS)
					&& (strucboucur < FVPNEXT))
				{
					/* First consonant of a two - consonant sequence */
					/* Default shortening is 70 percent */
					arg1 = N70PRCNT;
					/* Length nasal by 1.5 if next cons is word-init */
					if (((feacur & FNASAL) IS_PLUS)
						&& ((pDphsettar->strucnex & FWINITC) IS_PLUS))
					{
						arg1 = N150PRCNT;
					}
					/* Also make min duration shorter for C's in a cluster */
					else
						durmin -= (durmin >> 2);
					/* Shorten [S,TH] followed by a plosive or [SH] */
					if ((phocur == USP_S) || (phocur == USP_TH))
					{
						if ((pDphsettar->feanex & FPLOSV) IS_PLUS)
						{
							/* Multiply by 0.5 */
							arg1 = FRAC_HALF;
						}
						if (pDphsettar->phonex_timing == USP_SH)
						{
							pDphsettar->durxx = NF15MS;
#ifdef MSDBG5
							printf ("durxx = NF15MS durxx=%d\n", pDphsettar->durxx);
#endif
							goto break3;
						}
					}
					arg2 = prcnt;
					prcnt = mlsh1 (arg1, arg2);
					
				}
				if (((fealas & FCONSON) IS_PLUS)
					&& ((struclas & FBOUNDARY) < FVPNEXT))
				{
					/* Second consonant of a two-consonant sequence */
					/* Multiply by 0.7 */
					arg1 = N70PRCNT;
					/* Also make min duration shorter for C's in a cluster */
					durmin -= (durmin >> 2);
					if ((feacur & FPLOSV) IS_PLUS)
					{
						/* Shorten plosive if preceded by [s] */
						/* Multiply by 0.6 */
						if (pholas == USP_S)
						{
							arg1 = N60PRCNT;
						}
						/* Shorten unstr plos if preceded by nasal */
						if ((fealas & FNASAL) IS_PLUS)
						{
							/* Multiply by 0.1 */
							if (strucstresscur IS_MINUS)
								arg1 = 1638;
						}
						/* OUT                      Do not shorten a plos preceded by a plos if ((fealas & FPLOSV) IS_PLUS) arg1 = FRAC_ONE;
						 * END OUT */
					}
					arg2 = prcnt;
					prcnt = mlsh1 (arg1, arg2);
					
				}
			}
		}
		/* Rule 14: Increase sonor dur if preceding plosive is aspirated */
		if ((feacur & FSON1) IS_PLUS)
		{
			if (((fealas & FVOICD) IS_MINUS)
				&& ((fealas & FPLOSV) IS_PLUS))
			{
				deldur = deldur + NF20MS;
				
			}
		}
		/* Rule 15: Increase duration of phrase-initial vowels (following silence) */
		if ((feacur & FVOWEL) IS_PLUS)
		{
			if (pholas == GEN_SIL)
			{
				deldur = deldur + NF20MS;
				
			}
		}
		/* Rule 16: Increase vowel dur if preceeded by non-nasal sonor conson */
		/* (May not apply to function words such as "was,were") */

		if ((feacur & FVOWEL) IS_PLUS)
		{
			if (((fealas & FSON2) IS_PLUS)
				&& ((fealas & FNASAL) IS_MINUS))
			{
				if (deldur == 0)
					deldur = NF20MS;
				
			}
		}
		/* Rule 17: More lengthening of segments if in a short phrase */
		/* added df temporarily -need to refine rule wtih tony. */

		if ((pDph_t->nallotot < 10) && (durinh != durmin))
		{

			/* 
			 * Each segment of [bab] lengthened by 19 ms  deldur += 
			 * (NF30MS - (pDph_t->nallotot>>1));
			 * prdurs(pDph_t,phocur,durinh,durmin,deldur,prcnt,17);                          
			 */
			/* eab don't like absolute duration added try this */
			/* WIH 11/27/95 Change prcnt = + 120 to prcnt += 80 */
			/* put it back t0 =+ 120  EAB someone changed it back to absolute duration this is clearly
			wrong as it blocks all previous rules 4/6/98*/
			prcnt += 30;
			
		}
	

/* Rule turned on again with slightly less reduction I think this will be OK*/
		/* 
		 * Rule 18:Shortening of prevocalic clustered semivowels clustered 
		 * on left by stop or frcative. Before this rule, many sounded like 
		 * syllabic reduced segmanents, so fruit sounded like feruit. */
		 
		if ((feacur & FSONCON) IS_PLUS && ((fealas & FOBST) IS_PLUS))
		{
			arg1 = prcnt;
			arg2 = N70PRCNT;
			prcnt = mlsh1 (arg1, arg2);
			

		}


		/* RULE 19: Shorten function word final TH as in "with: */
		if                      ((phocur == USP_TH) && ((struccur & FTYPESYL) == FMONOSYL) &&
								                         (strucboucur >= FWBNEXT) &&
								                         (strucstresscur == FNOSTRESS))
		{
			arg1 = prcnt;
			arg2 = N60PRCNT;
			prcnt = mlsh1 (arg1, arg2);
			

		}

		/* RULE 20: lengthen i in "the"("me,he" also OK followed by vowel */
		if ((phocur == USP_IY) && ((struccur & FBOUNDARY) > FMBNEXT) &&
			(strucstresscur == FNOSTRESS) &&
			((struccur & FTYPESYL) == FMONOSYL))
		{
			arg1 = prcnt;
			arg2 = N150PRCNT;
			prcnt = mlsh1 (arg1, arg2);
			
		}
		/* 
		 * RULE 21 SHorten stop following a stop and preceding a fricative 
		 * within the same sylable. Before this words like products have just as long 
		 * a /k/ and /t/ as a word missing the other stop would have, whereas in
		 * reality the /t/ should be reduced greatly. Cut minimum duration in
		 * half, and reduce the multiplier a lot. Probably actually want to reduce 
		 * this eve more. 
		 */

		if (((feacur & FPLOSV) IS_PLUS) &&
			((fealas & FPLOSV) IS_PLUS) &&
			((pDphsettar->feanex & FOBST) IS_PLUS) &&
			(strucboucur > FMBNEXT))

		{
			durmin = durmin >> 1;
			arg1 = prcnt;
			arg2 = N25PRCNT;
			prcnt = mlsh1 (arg1, arg2);
			
		}

		/* rule 23  shorten vowel if phonex == df writing versus riding */
		/* Improve rule by preventing it from firing if already  reduced*/
		if (pDphsettar->phonex_timing == USP_DF)
		{
			if(prcnt > 50)
			{
				arg1 = prcnt;
				arg2 = N40PRCNT;
				prcnt = mlsh1 (arg1, arg2);
			}
			
		}
#ifdef NWS_US
		// 5/26/99 BATS 894 Inter vocalic t are no longer flapped for better articualtion but
		//the timing rule of American English still needs to fire...
			/* rule 23  shorten vowel if phonex == df writing versus riding */
		/* Improve rule by preventing it from firing if already  reduced*/
		//eab 5/25/98 In the nws_us version df isn't produced for better articulation 
		//but the timing rule for the vowels still needs to occur
		if (pDphsettar->phonex_timing == USP_T
			&& ((feacur & FVOWEL) IS_PLUS)
			&&((phone_feature( pDph_t ,pDph_t->allophons[nphon+2]) & FVOWEL) IS_PLUS)
			&& nphon+2 <= pDph_t->nallotot)
		{
			if(prcnt > 50)
			{
				arg1 = prcnt;
				arg2 = N35PRCNT;
				prcnt = mlsh1 (arg1, arg2);
			}
			
		}
#endif


		/* RULE 24: Suggested by EVAN "ing's" were too long analysis showed
		that the vowel needed reduction */
		if (pDph_t->allophons[nphon+1] == USP_NX)
		{
			arg1 = prcnt;
			arg2 = N50PRCNT;
			prcnt = mlsh1 (arg1, arg2);
			
		}
		//10/14/00 EAB baaggerly and eagerrly showed that the rr can get shorten too much
		//being retroflexed it needs a minimum minudr won't do it because that minimum in a stressed situation
		if(phocur == USP_RR)
		{
			if(durmin <=13)
				durmin=13;
		}


		pDphsettar->strucstressprev = strucstresscur;

		/* Finish up */

		/* Set duration from durinh, durmin, and percent */
		pDphsettar->durxx = (prcnt * (durinh - durmin)) DIV_BY128;
#ifdef MSDBG5
		printf ("durxx = (prcnt * (durinh - durmin)) DIV_BY128 durxx=%d\n", pDphsettar->durxx);
#endif
		pDphsettar->durxx += durmin;   /* SHOULD BE DONE AFTER SPRATE ADJUSTMENT */
#ifdef MSDBG5
		printf ("durxx += durmin durxx=%d\n", pDphsettar->durxx);
#endif

	/* Rule for slow speaking lengthen inserted glotal stop*/



		if(phocur == USP_Q && pKsd_t->sprate< 75)
			pDphsettar->durxx = 1+((80-pKsd_t->sprate) );

		/* Effect of speaking rate */
		if ((pDphsettar->sprat0 != 180) && (pDphsettar->durxx != 0))
		{
			arg1 = pDphsettar->durxx;
			arg2 = pDphsettar->sprat2;
			pDphsettar->durxx = mlsh1 (arg1, arg2) + 1;		/* Round upwards */

#ifdef MSDBG5
			printf ("durxx = mlsh1(arg1,arg2)+1 durxx=%d\n", pDphsettar->durxx);
#endif

			/* Effect of speaking rate on additive increment to dur */
			arg1 = deldur;
			arg2 = pDphsettar->sprat1;
			deldur = mlsh1 (arg1, arg2);
		}
		/* Add in rule-governed additive increment to dur  */
		pDphsettar->durxx = pDphsettar->durxx + deldur;
#ifdef MSDBG5
		printf ("durxx = durxx + deldur durxx=%d\n", pDphsettar->durxx);
#endif

	if (pDphsettar->durxx < 0 ) /*eab oct 93 found dur could get set =0 compromise*/
		pDphsettar->durxx=1;    /*over putting command later(safer) see comment above*/

break3:  //Need to change this location for stressed timed and singing to both work correctly eab 12/1/98
		pDph_t->allodurs[nphon] = pDphsettar->durxx;	   /* Save in array for phonetic comp */
		if (pDph_t->allophons[nphon] != GEN_SIL)	   			   /* don't count silence 			  */
		{
			/* printf("add %d for phon %d\n",pDphsettar->durxx,pDph_t->allophons[nphon]); 	  */
			//EAB 11/20/98 In English this is really not syldur but duration between stess as English
			//is a stressed timed language. The code was origianlly down for a syllable timed language hence hte syldur nomiclature
			syldur += pDphsettar->durxx;
		}
			/* Instead of counting vowels now count sonorants */
		if ((feacur & FSON1) IS_PLUS && pDph_t->allophons[nphon] != 0)
		{
			/* printf("+voe on  %d sonocnt=%d\n",pDph_t->allophons[nphon],sonocnt); */
			sonocnt++;
		}
//		if ((((struccur & FISBOUND) == FISBOUND) && nphon != 0 || nphon == pDph_t->nallotot - 2))
		//EAB 11/20/98 Found that consonants before vowel are also marked with stress and these we want to ignore here
		
		if( ((struccur & FSTRESS) IS_PLUS))
			if((feasyllabiccur IS_PLUS) )
				//eab 2/1/99 kludge for testing first stressed 
				//gets mangled hack alert until we know what the real rule shuld be
		{
			/* printf("strucc=%o of phon %d at %d",struccur,pDph_t->allophons[nphon],nphon); */
#ifdef DEBUGPHT
			printf (" 2fbound struccur%o, p= %d\n", struccur, pDph_t->allophons[nphon]);
			printf ("syldur = %d \n ", (syldur * 64) / 10);
			printf ("sonocnt=%d\n", sonocnt);
#endif
			switch (sonocnt)
			{
			case 1:

				adjust = (pDph_t->timeref - (syldur ));
				break;
			case 2:
				adjust = ((pDph_t->timeref - (syldur )) >> 1);
				break;
			case 3:
				/* do 3/8 instead of divide by 3 */
				adjust = ((pDph_t->timeref - (syldur )) >> 3) * 3+1;
				break;
			case 4:
				adjust = ((pDph_t->timeref - (syldur )) >> 2)+1;
				break;
			case 5:
				adjust = ((pDph_t->timeref - (syldur )) >> 3);
				break;
			case 6:
				adjust = ((pDph_t->timeref - (syldur )) >> 4 );
				break;
			case 7:
				adjust = ((pDph_t->timeref - (syldur )) >> 5);
				break;
			case 8:
				adjust = ((pDph_t->timeref - (syldur )) >> 6);
				break;
			case 9:
				adjust = ((pDph_t->timeref - (syldur )) >> 7);
				break;
			case 10:
				adjust = ((pDph_t->timeref - (syldur )) >> 8);
				break;

			default:
				adjust = ((pDph_t->timeref - (syldur )) >> 7);

#ifdef DEBUGPHT
				printf ("WHY HERE??");
				printf ("sonocnt=%d phon= %d nphon= %d\n", sonocnt, pDph_t->allophons[nphon], nphon);
#endif

			//	WINprintf("%d vcnt %d\n ",adjust,sonocnt);
				break;
			}

			/* 0015 EAB     06/11/97		Added in Fasttalk time alignement feature */
#ifdef FASTTALK
		if (pDphsettar->sprat0 <= 250) /* note above 250 sprat0=250+(sprat-250)>>1 */
			{
			adjust=0;
			}
		else if(pDphsettar->sprat0 >= 270)
			adjust = adjust>>1;
		else if(pDphsettar->sprat0 >= 250)
			//round up!
			adjust = (adjust+1)>>2;
#endif
		//adjust=0;
		if(nphon < 3 ) //first stress at begining vowel of a stessed word reduce effect
		{
			adjust=adjust>>3;
		}
		else
		{
				//round up!
			adjust = ((adjust+1)>>1)+1;
		}
		if (pDph_t->user_durs[nphon] != 0 || pDph_t->f0mode == SINGING)
		{
			adjust = 0;
		}

		//WINprintf("stcnt %d endcnt %d \n",stcnt,nphon);

		

		for (endcnt = nphon-1; stcnt - (endcnt); endcnt--)
		{
				 //dologphoneme(pDph_t->allophons[endcnt],0,0); 
				 //WINprintf("nphon %d ",endcnt); printf("p=%d ",pDph_t->allophons[endcnt]);

				/*  printf("ph=%d ",pDph_t->allophons[endcnt]); */
				/* if( pDph_t->allophons[endcnt] <= 7 && pDph_t->allophons[endcnt] >0) */
				/* change from adjusting just vowels to any sonorant */
                                        /* 0028 MGS 09/29/1997 Comment out the bad dologphoneme */
                                        //dologphoneme(phTTS,pDph_t->allophons[endcnt],0,0);
					 

				if ((phone_feature( pDph_t ,pDph_t->allophons[endcnt]) & FSONOR) IS_PLUS)
				{
					
//					  WINprintf(" dur %d syldur=%d adj=%d \n"
//						  ,pDph_t->allodurs[endcnt],
//				  (syldur*64)/10,adjust); 
					


					//printf ("set  %d dur %d syldur=%d adj=%d", pDph_t->allophons[endcnt], pDph_t->allodurs[endcnt], (syldur * 64) / 10, adjust);


					pDph_t->allodurs[endcnt] += adjust;
					if (pDph_t->allodurs[endcnt] <=6)
						pDph_t->allodurs[endcnt]=6;

					

					//printf ("to  %d \n", ((pDph_t->allodurs[endcnt] * NSAMP_FRAME) / 10));

		
					ncnt++;
				}
			}
			/* 
			 * printf("set  syldur from %d to %d in %d adjusts.\n",
			 * ((syldur)*64)/10,((syldur+(ncnt*adjust))*64)/10,ncnt ); 
			 */
			ncnt = 0;
			/* printf("-- \n"); */
			stcnt = nphon;
			/* reset slydur */
			syldur = 0;
			sonocnt = 0;

		}


//		printf ("final duration = %d  durxx  \n", ((pDphsettar->durxx * NSAMP_FRAME) + 5) / 10);


	  //break3:

		/* ccc change for 1/2 sample */

		if (NSAMP_FRAME == 128)
			pDphsettar->durxx = (pDphsettar->durxx >> 1);	/* Save in array for phonetic comp */

		

	

#ifdef NEWTYPING_MODE
	/* Note to CARL we need to check this with TOM it's a bettter algorithm
	becuase the thing that really counts is the number of sonorants not the number
	of phonemes also the ifdef Spanish was dumb as this is a US only file
	Better fic of BATS 465 */
		if(phTTS->bInTypingMode == TRUE)
		{
			minsize= 30/numbersonor;
			if (minsize < 6)
				minsize=6;
			if((feacur & FSONOR) IS_PLUS && phocur != GEN_SIL) 
			{
				pDph_t->allodurs[nphon]= minsize;
				
			}

			else
			{

				if(pDph_t->allophons[nphon] == S)

				{
					pDph_t->allodurs[nphon]=5;
				
				}
				else
				{
					pDph_t->allodurs[nphon]=3;
					
				}
			}
			
		}
#endif /* typing mode*/
#ifdef TYPING_MODE  /*-DR 09/24/1997 Added to FIX BATS465*/
		
		if(phTTS->bInTypingMode == TRUE)
		{
			minsize= 30/(pDph_t->nallotot-1);
			if (minsize < 6)
				minsize=6;
			if((feacur & FSONOR) IS_PLUS && phocur != GEN_SIL) 
				pDph_t->allodurs[nphon]= minsize;
			else
			{
#ifdef ENGLISH_US /*-DR 9/23/97 should eventually change to ENGLISH for both UK and US*/
				if(pDph_t->allophons[nphon] == USP_S)
#endif
#ifdef SPANISH
					if(pDph_t->allophons[nphon] == E_S)
#endif
						pDph_t->allodurs[nphon]=5;
					else
						pDph_t->allodurs[nphon]=1;
			}
		}
#endif /* typping mode*/



#ifdef MSDBG4
		printf ("allodurs[nphon] = durxx allodurs[%d]=%d\n", nphon, pDph_t->allodurs[nphon]);
#endif
		pDph_t->longcumdur += (pDphsettar->durxx * NSAMP_FRAME);	/* Cum dur in waveform samples     */
	}
	
}

