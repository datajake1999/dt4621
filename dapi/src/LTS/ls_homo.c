/*
 ***********************************************************************
 *                                                                      
 *                           Copyright �
 *	  Copyright � 2000 Force Computers, a Solectron Company. All rights reserved.
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
 *    File Name:	ls_homo.c
 *    Author:		Matthew Schnee                                         
 *    Creation Date:02/06/96                                                   
 *                                                                             
 *    Functionality:                                                           
 *                                                                             
 *                                                                             
 ***********************************************************************       
 *                                                                             
 * Rev	Who      Date            Description                    
 * ---	-----	-----------	---------------------------------------
 * 001	MGS     03/18/1996      Finished WIN32 code merge, function headers need updating
 * 002  GL      05/12/1996      move the pronunce (primary and secondary)
 *                              flag checking before formclass checking.
 *                              also fix the bug of "to lead"
 * 003	GL      10/01/1996      fix the bug while hitting the DEP.fc with HTAB.h_select.
 * 004	GL      11/04/1996      force to use the primary for first word.
 * 005  GL      01/31/1997      force 004 apply to "wind" only
 * 006  GL      03/03/1997      fix BATS#276 problem "have alread read"
 *                              check the word before "adv" to apply the rule.
 * 007  GL      10/22/1997      disable the "first word, verb" rule for NWS.
 * 008	MFG     04/28/1998      added dbglog.txt logging for [:debug 4020]
 * 009  MFG     05/19/1998      excluded dbglog logging when build 16-bit code (MSDOS)	 
 * 010  GL      07/08/1998      For BATS#705 don't set formclass to noun for words with unknown
 *                              formclass for PH, but use "noun" here for homograph processing
 * 011  GL      09/29/1998      remove FC_CHARACTER from primary entry form class data
 * 012  EAB     02/02/1999      Made NWSNOAA->NWS_US change to support more than nwsnooa for english only
 * 013  EAB     03/21/2000      Homographs broken since 1996 ginger didn't 
 *                              undersand how they were suppose to work.
 * 014	NAL     06/12/2000      Warning removal
 * 015	NAL		07/25/2000		Added ls_homo_sapi_homo for homophone resolution in SAPI5 lexicons
 * 016	MGS		10/05/2000		Redhat 6.2 and linux warning removal
 * 017 	CAB		10/16/2000		Added copyright info
 */

#include "ls_def.h"
#include "ls_homo.h"

/*#define HDEBUG 1*/
#define	DEP		(*entry_primary)
#define	DES		(*entry_secondary)
#define	HTAB	homo_table[i]


/*
 *	Function Name:
 *		ls_homo_homo	
 *
 *	Description:
 *		this function does homograph processing
 *
 *	Arguments:                                 
 *		int index	the index into the dictionary
 *
 *	Return Value:                                
 *		struct dic_entry *	a pointer to the entry in the dictionary that
 *							will be pronounced
 *
 *	Comments:
 *  	ls_homo_homo() disambiguates between two dictionary homographs ...
 *
 */
struct dic_entry far *ls_homo_homo(LPTTS_HANDLE_T phTTS,long index)
{
	struct dic_entry far *entry_temporary;
	struct dic_entry far *entry_primary;
	struct dic_entry far *entry_secondary;
	int	i,try_other; 
	PLTS_T	pLts_t;
	PKSD_T	pKsd_t;


	pLts_t = phTTS->pLTSThreadData;
	pKsd_t = phTTS->pKernelShareData;   

	/*
	 *  homograph is either right before this or right after ...
	 */

	entry_primary = DICT_ACCESS(index-1);
	entry_secondary = DICT_ACCESS(index);
	try_other = true;

	if(DES.fc & FC_HOMOGRAPH)
	{
		for(i=0;DES.text[i];i++)
		{
			if(DEP.text[i] != DES.text[i])
			{
#ifdef HDEBUG
				printf("at2 %d %d \n",entry_primary,entry_secondary);
    			printf("landed incor \n");
#endif
				break;
			}
		}
		if(DEP.text[i] == '\0' && DES.text[i] == '\0')
		{
#ifdef HDEBUG
			printf("landed cor \n");
#endif

			try_other = false;
		}
	}
	if(try_other)
	{
		index++;
		entry_primary = DICT_ACCESS(index-1);
		entry_secondary = DICT_ACCESS(index);
		if(DES.fc & FC_HOMOGRAPH)
		{

			for(i=0;DES.text[i];i++)
			{
				if(DEP.text[i] != DES.text[i])
				{
#ifdef HDEBUG
					printf("plus and minus failed???");
#endif
					break;

				}
			}
			if(DEP.text[i] == '\0' && DES.text[i] == '\0')
			{
				/*match on + code so primnary=index+1 */
#ifdef HDEBUG
				printf("gtcha. reversing.");
#endif
				if(DES.fc & FC_CHARACTER)
				{

					entry_primary = entry_secondary;
					entry_secondary = DICT_ACCESS(index);
#ifdef HDEBUG

		printf("rever again");
#endif
				}	
				try_other = false;
			}
		}
			
	}

	/* GL 09/29/98, remove the FC_CHARACTER which is used as primary homo indicator */
#if 0 //This code is dumb. MGS 07/14/00
	if(DEP.fc & FC_CHARACTER)
	{

	    DEP.fc = DEP.fc & ~FC_CHARACTER;
	}
#endif
	
	if(try_other)
	{
		return(entry_primary);
	}

	/*
	 *  set the primary and secondary field correctly ...
	 */

	/*
	 *  change 5/12/96, GL
	 *  both primary and alternate only apply to next word only.
	 */
	
        if(pKsd_t->pronflag & PRON_DIC_PRIMARY)
        {
                pKsd_t->pronflag &= (~PRON_DIC_PRIMARY);
                return(entry_primary);
        }
        if(pKsd_t->pronflag & PRON_DIC_ALTERNATE)
        {
                pKsd_t->pronflag &= (~PRON_DIC_ALTERNATE);
                return(entry_secondary);
		}


		if(pKsd_t->pronflag & PRON_DIC_NOUN)
        {
			pKsd_t->pronflag &= (~PRON_DIC_NOUN);
			if(DEP.fc & FC_NOUN)
				return(entry_primary);
			if(DES.fc & FC_NOUN)
				return(entry_secondary);
			return(entry_primary);
        }
		if(pKsd_t->pronflag & PRON_DIC_VERB)
        {
			pKsd_t->pronflag &= (~PRON_DIC_VERB);
			if(DEP.fc & FC_VERB)
				return(entry_primary);
			if(DES.fc & FC_VERB)
				return(entry_secondary);
			return(entry_primary);
        }
		if(pKsd_t->pronflag & PRON_DIC_ADJECTIVE)
        {
			pKsd_t->pronflag &= (~PRON_DIC_ADJECTIVE);
			if(DEP.fc & FC_ADJ)
				return(entry_primary);
			if(DES.fc & FC_ADJ)
				return(entry_secondary);
			return(entry_primary);
        }
		if(pKsd_t->pronflag & PRON_DIC_FUNCTION)
        {
			pKsd_t->pronflag &= (~PRON_DIC_FUNCTION);
			if(DEP.fc & FC_FUNC)			/*?? NAL I don't think FUNC (for functor?) is the same as SAPI's "function" */
				return(entry_primary);
			if(DES.fc & FC_FUNC)
				return(entry_secondary);
			return(entry_primary);
        }
		if(pKsd_t->pronflag & PRON_DIC_INTERJECTION)
        {
			pKsd_t->pronflag &= (~PRON_DIC_INTERJECTION);
			if(DEP.fc & FC_INTER)
				return(entry_primary);
			if(DES.fc & FC_INTER)
				return(entry_secondary);
			return(entry_primary);
        }

        /*
           force the first word to pick up the verb. this may not be 100% right but is better
           then dangling there
		   GL 11/04/1996, change to pick up the primary for first word. This could also
		   break some other word since we have no idea which formclass we should use.
		   we ned to lookahead the formclass of next word someday..
		   GL 1/31/1997, actually only "wind" will be the problem for "first word verb"
		   rule.  So force to pick up the primary for "wind" only.
		   can't use strnicmp() in DECtalk kernel
           GL 10/22/1997, wind is set to primary in dictionary, so first word always
		   is primary as the way V42C work(for NWS only)
		   EAB 3/21/0000 This is an incorrect assumption in fact tony tried to code it so that the primary
		   entry was the best default.
		*/
        if(pLts_t->fc_index == 1)
        {

           		return(entry_primary);



        }

    /*
	   GL 07/08/1998 BATS#705 set the previous wordclass to noun if
	                          it is unknown.  Since we did some dictionary
							  reduction for "noun" word for dual language
							  (US+SP) express, this guess should provide
							  the formclass information for these words
							  which got removed.
	*/
    if (pLts_t->fc_struct[pLts_t->fc_index-1] == 0)
         pLts_t->fc_struct[pLts_t->fc_index-1] = 0x400;



	/*
	 *  Now run through the list and try to pick one ...
	 */

	for(i=0;i<MAX_HOMO_RULE;i++)
	{
		/*
		 *  First, if there is no suffix for this rule or the suffix matches a
		 *  stripped suffix ...
		 */
		if(HTAB.h_suffix == 0 || ((HTAB.h_suffix & pLts_t->fc_struct[pLts_t->fc_index]) == (unsigned int)HTAB.h_suffix)) // NAL warning removal
		{
		    /* GL 3/3/1997 check the word before previous word if
		       previous word is a Adv. */
			if(HTAB.h_context == 0 ||
			  (HTAB.h_context & pLts_t->fc_struct[pLts_t->fc_index-1]) ||
			  ((pLts_t->fc_index >= 3) &&
			   (FC_ADV & pLts_t->fc_struct[pLts_t->fc_index-1]) &&
			   (HTAB.h_context & pLts_t->fc_struct[pLts_t->fc_index-2])))
			{
				/* debug switch */
				if (DT_DBG(LTS_DBG,0x020))
				{
#ifndef MSDOS
					if (pKsd_t->dbglog)			/*mfg 04/28/98 added debug support*/
					fprintf((FILE *)pKsd_t->dbglog,"\nHOMO:(%d)",i);
#endif    
			   		printf("\nHOMO:(%d)",i);
				}
#ifdef HDEBUG
				printf(" got context at %d \n",i);
#endif

				if(HTAB.h_select)
				{
/*					if( (HTAB.h_select & DEP.fc) == 0)
						{
						break;
						} */						
					/* GL, 10/01/1996, if match the primary formclass then should get out of loop */
					if (HTAB.h_select & DEP.fc)
					{
						break;
					}						
					if(HTAB.h_select & DES.fc)
					{
#ifdef HDEBUG
						printf("changing primary to secondary1. rule i %d\n",i);
						printf(" %d %d \n",entry_primary,entry_secondary);
#endif

						entry_temporary = entry_primary;
						entry_primary = entry_secondary;
						entry_secondary = entry_temporary;

						break;

					}
				}
				if(HTAB.h_elim)
				{
					if(HTAB.h_elim & DES.fc)
						break;
					if(HTAB.h_elim & DEP.fc)
					{
#ifdef HDEBUG
						printf("changing primary to secondary2. rule %d\n",i);
#endif

						entry_temporary = entry_primary;
						entry_primary = entry_secondary;
						entry_secondary = entry_temporary;
						break;
					}
				}
			}
		}
	}

	if((i < MAX_HOMO_RULE) && HTAB.h_suffix)
	{
		pLts_t->fc_struct[pLts_t->fc_index] = DEP.fc;
	}

	return(entry_primary);

}


#ifdef __osf__
int ls_homo_sapi_homo(LPTTS_HANDLE_T phTTS, unsigned  int fc1, unsigned  int fc2)
{
	unsigned  int TEMPfc;
#else
int ls_homo_sapi_homo(LPTTS_HANDLE_T phTTS, unsigned long fc1, unsigned long fc2)
{
	unsigned long TEMPfc;
#endif
	int i=0;

	PLTS_T	pLts_t;
	PKSD_T	pKsd_t;

	pLts_t = phTTS->pLTSThreadData;
	pKsd_t = phTTS->pKernelShareData;   

	for(i=0;i<MAX_HOMO_RULE;i++)
	{
		/*
		 *  First, if there is no suffix for this rule or the suffix matches a
		 *  stripped suffix ...
		 */
		if(HTAB.h_suffix == 0 || ((HTAB.h_suffix & pLts_t->fc_struct[pLts_t->fc_index]) == (unsigned int)HTAB.h_suffix)) // NAL warning removal
		{
		    /* GL 3/3/1997 check the word before previous word if
		       previous word is a Adv. */
			if(HTAB.h_context == 0 ||
			  (HTAB.h_context & pLts_t->fc_struct[pLts_t->fc_index-1]) ||
			  ((pLts_t->fc_index >= 3) &&
			   (FC_ADV & pLts_t->fc_struct[pLts_t->fc_index-1]) &&
			   (HTAB.h_context & pLts_t->fc_struct[pLts_t->fc_index-2])))
			{
				/* debug switch */
				if (DT_DBG(LTS_DBG,0x020))
				{
#ifndef MSDOS
					if (pKsd_t->dbglog)			/*mfg 04/28/98 added debug support*/
					fprintf((FILE *)pKsd_t->dbglog,"\nHOMO:(%d)",i);
#endif    
			   		printf("\nHOMO:(%d)",i);
				}
#ifdef HDEBUG
				printf(" got context at %d \n",i);
#endif

				if(HTAB.h_select)
				{
					if (HTAB.h_select & fc1)
					{
						break;
					}						
					if(HTAB.h_select & fc2)
					{
						TEMPfc = fc1;
						fc1 = fc2;
						fc2 = TEMPfc;
						break;
					}
				}
				if(HTAB.h_elim)
				{
					if(HTAB.h_elim & fc2)
						break;
					if(HTAB.h_elim & fc1)
					{
						TEMPfc = fc1;
						fc1 = fc2;
						fc2 = fc1;
						break;
					}
				}
			}
		}
	}

	if((i < MAX_HOMO_RULE) && HTAB.h_suffix)
	{
		pLts_t->fc_struct[pLts_t->fc_index] = fc1;
	}

	return(fc1);

}





