/*
 ***********************************************************************
 *
 *                           Copyright �
 *    Copyright � 2000 Force Computer, Inc., a Solectron company. All rights reserved.
 *    Digital Equipment Corporation 1996, 1997. All rights reserved.
 *
 *    Restricted Rights: Use, duplication, or disclosure by the U.S.
 *    Government is subject to restrictions as set forth in subparagraph
 *    (c) (1) (ii) of DFARS 252.227-7013, or in FAR 52.227-19, or in FAR
 *    52.227-14 Alt. III, as applicable.
 *
 *    This software is proprietary to and embodies the confidential
 *    technology of Force Computer Incorporated and other parties.
 *    Possession, use, or copying of this software and media is authorized
 *    only pursuant to a valid written license from Force or an
 *    authorized sublicensor.
 *
 ***********************************************************************
 *    File Name:        cm_char.c
 *    Author:
 *    Creation Date:
 *
 *    Functionality:
 *    char_accept() is used in word mode to quickly decide wether or not
 *    to continue accepting characters or to pass 0xb before the next.
 *
 ***********************************************************************
 *    Revision History:
 *
 * Rev	Who		Date		Description
 * ---  ------	-----------	--------------------------------------------
 *	
 * 001	CJL		01/25/1996	Added comments to each entry for sanity.
 *                   		Updated MARKs for non-English chars.
 * 002	CJL		01/26/1996 	Corrected ASCII to ISO for > 7E.
 * 003	GL		02/01/1996  change 0xa1, 0xb7 and 0xbf to _punct
 * 004	EAB		02/02/1996  add new table nchar_TYPE2s[] for Span Pre-processing.
 * 005	GL		02/12/1996  restore 0xdf to MARK_cons
 * 006	MGS		05/15/1996	Removed EAB's char_nTYPE2s table
 *							this table is now in par_char.c with the 
 * 							name parser_char_TYPE2s
 * 007  SIK		07/08/1996  Cleaning up and maintenance 
 * 008  SIK 	10/10/1996  Added old nchar_TYPE2s table to work with VOCAL code 
 * 009	CAB		10/18/2000	Changed copyright info and formatted comments
 */

#include	"cm_def.h"
unsigned char char_types[]= {

/* dec    hex     printable  char          non-printable char   */
/* num    num     char       TYPE2          description          */
/*                                                              */
/*  0     00      nul	*/	MARK_null+MARK_digit,                                          
/*  1     01      soh	*/	MARK_null,				/* 0x00 to 0x0f */
/*  2     02      stx	*/	MARK_null,
/*  3     03      etx	*/	MARK_null,
/*  4     04      eot	*/	MARK_null,
/*  5     05      enq	*/	MARK_null,	
/*  6     06      ack	*/	MARK_null,
/*  7     07      bel	*/	MARK_space,
/*  8     08      bs	*/	MARK_space,
/*  9     09      ht	*/	MARK_clause,	
/* 10     0A      nl	*/	MARK_null+MARK_space,
/* 11     0B      vt	*/	MARK_null+MARK_clause+MARK_space,
/* 12     0C      ff	*/	MARK_null+MARK_space,
/* 13     0D      cr	*/	MARK_null+MARK_space,	
/* 14     0E      so	*/	MARK_null,
/* 15     0F      si	*/	MARK_space,
/* 16     10      dle	*/	MARK_null,
/* 17     11      dc1	*/	MARK_null+MARK_digit,	/* 0x10 to 0x1f */
/* 18     12      dc2	*/	MARK_null,
/* 19     13      dc3	*/	MARK_null,
/* 20     14      dc4	*/	MARK_null,
/* 21     15      nak	*/	MARK_null,	
/* 22     16      syn	*/	MARK_null,
/* 23     17      etb	*/	MARK_null,
/* 24     18      can	*/	MARK_null,
/* 25     19      em	*/	MARK_null,	
/* 26     1A      sub	*/	MARK_null,
/* 27     1B      esc	*/	MARK_null,
/* 28     1C      fs	*/	MARK_null,
/* 29     1D      gs	*/	MARK_null,	
/* 30     1E      rs	*/	MARK_null,
/* 31     1F      us	*/	MARK_null,
/* 32     20      sp	*/	MARK_space,
/* 33     21      !		*/	MARK_punct+MARK_clause,	/* 0x20 to 0x2f */
/* 34     22      "		*/	MARK_punct,
/* 35     23      #		*/	MARK_non_alpha,
/* 36     24      $		*/	MARK_cons+MARK_digit,
/* 37     25      %		*/	MARK_non_alpha+MARK_digit,	/*eab change $ to aloha */
/* 38     26      &		*/	MARK_cons,
/* 39     27      '		*/	MARK_punct+MARK_clause, 	/* change & to equal a cons*/
/* 40     28      (		*/	MARK_non_alpha+MARK_digit,
/* 41     29      )		*/	MARK_non_alpha+MARK_digit,  	
/* 42     2A      *		*/	MARK_non_alpha,
/* 43     2B      +		*/	MARK_non_alpha+MARK_digit,
/* 44     2C      ,		*/	MARK_punct+MARK_clause,
/* 45     2D      -		*/	MARK_punct+MARK_clause,		
/* 46     2E      .		*/	MARK_punct+MARK_clause,
/* 47     2F      /		*/	MARK_punct+MARK_digit,
/* 48     30      0		*/	MARK_digit,
/* 49     31      1		*/	MARK_digit,					/* 0x30 to 0x3f */
/* 50     32      2		*/	MARK_digit,
/* 51     33      3		*/	MARK_digit,
/* 52     34      4		*/	MARK_digit,
/* 53     35      5		*/	MARK_digit,
/* 54     36      6		*/	MARK_digit,
/* 55     37      7		*/	MARK_digit,
/* 56     38      8		*/	MARK_digit,
/* 57     39      9		*/	MARK_digit,
/* 58     3A      :		*/	MARK_punct+MARK_clause,
/* 59     3B      ;		*/	MARK_punct+MARK_clause,
/* 60     3C      <		*/	MARK_non_alpha,
/* 61     3D      =		*/	MARK_non_alpha+MARK_digit,	
/* 62     3E      >		*/	MARK_non_alpha,
/* 63     3F      ?		*/	MARK_punct+MARK_clause,
/* 64     40      @		*/	MARK_non_alpha,
/* 65     41      A		*/	MARK_upper+MARK_vowel,	/* 0x40 to 0x4f */
/* 66     42      B		*/	MARK_upper+MARK_cons,
/* 67     43      C		*/	MARK_upper+MARK_cons,
/* 68     44      D		*/	MARK_upper+MARK_cons,
/* 69     45      E		*/	MARK_upper+MARK_vowel,	
/* 70     46      F		*/	MARK_upper+MARK_cons,
/* 71     47      G		*/	MARK_upper+MARK_cons,
/* 72     48      H		*/	MARK_upper+MARK_cons,
/* 73     49      I		*/	MARK_upper+MARK_vowel,	
/* 74     4A      J		*/	MARK_upper+MARK_cons,
/* 75     4B      K		*/	MARK_upper+MARK_cons,
/* 76     4C      L		*/	MARK_upper+MARK_cons,
/* 77     4D      M		*/	MARK_upper+MARK_cons,	
/* 78     4E      N		*/	MARK_upper+MARK_cons,
/* 79     4F      O		*/	MARK_upper+MARK_vowel,
/* 80     50      P		*/	MARK_upper+MARK_cons,
/* 81     51      Q		*/	MARK_upper+MARK_cons,	/* 0x50 to 0x5f */			
/* 82     52      R		*/	MARK_upper+MARK_cons,
/* 83     53      S		*/	MARK_upper+MARK_cons,
/* 84     54      T		*/	MARK_upper+MARK_cons,
/* 85     55      U		*/	MARK_upper+MARK_vowel,				
/* 86     56      V		*/	MARK_upper+MARK_cons,
/* 87     57      W		*/	MARK_upper+MARK_cons,
/* 88     58      X		*/	MARK_upper+MARK_cons,
/* 89     59      Y		*/	MARK_upper+MARK_cons+MARK_vowel,	
/* 90     5A      Z		*/	MARK_upper+MARK_cons,
/* 91     5B      [		*/	MARK_null,
/* 92     5C      \		*/	MARK_punct,
/* 93     5D      ]		*/	MARK_non_alpha,						
/* 94     5E      ^		*/	MARK_non_alpha,
/* 95     5F      _		*/	MARK_null,
/* 96     60      `		*/	MARK_non_alpha,
/* 97     61      a		*/	MARK_vowel,				/* 0x60 to 0x6f */
/* 98     62      b		*/	MARK_cons,
/* 99     63      c		*/	MARK_cons,
/*100     64      d		*/	MARK_cons,
/*101     65      e		*/	MARK_vowel,	
/*102     66      f		*/	MARK_cons,
/*103     67      g		*/	MARK_cons,
/*104     68      h		*/	MARK_cons,
/*105     69      i		*/	MARK_vowel,
/*106     6A      j		*/	MARK_cons,
/*107     6B      k		*/	MARK_cons,
/*108     6C      l		*/	MARK_cons,
/*109     6D      m		*/	MARK_cons,
/*110     6E      n		*/	MARK_cons,
/*111     6F      o		*/	MARK_vowel,
/*112     70      p		*/	MARK_cons,
/*113     71      q		*/	MARK_cons,				/* 0x70 to 0x7f */
/*114     72      r		*/	MARK_cons,
/*115     73      s		*/	MARK_cons,
/*116     74      t		*/	MARK_cons,
/*117     75      u		*/	MARK_vowel,					
/*118     76      v		*/	MARK_cons,
/*119     77      w		*/	MARK_cons,
/*120     78      x		*/	MARK_cons,
/*121     79      y		*/	MARK_cons+MARK_vowel,	
/*122     7A      z		*/	MARK_cons,
/*123     7B      {		*/	MARK_non_alpha,
/*124     7C      |		*/	MARK_non_alpha,
/*125     7D      }		*/	MARK_non_alpha,			
/*126     7E      ~		*/	MARK_non_alpha,
/*127     7F      		*/	MARK_null,
/*128     80       		*/	MARK_null,
/*129     81       		*/	MARK_null,				/* 0x80 to 0x8f */	
/*130     82       		*/	MARK_null,
/*131     83       		*/	MARK_null,
/*132     84       		*/	MARK_null,
/*133     85       		*/	MARK_null,	
/*134     86       		*/	MARK_null,
/*135     87       		*/	MARK_null,
/*136     88       		*/	MARK_null,
/*137     89        		*/	MARK_null,	
/*138     8A       		*/	MARK_null,
/*139     8B       		*/	MARK_null,
/*140     8C       		*/	MARK_null,
/*141     8D       		*/	MARK_null,	
/*142     8E       		*/	MARK_null,
/*143     8F       		*/	MARK_null,
/*144     90       		*/	MARK_null,
/*145     91       		*/	MARK_null,				/* 0x90 to 0x9f */
/*146     92       		*/	MARK_null,
/*147     93       		*/	MARK_null,
/*148     94       		*/	MARK_null,
/*149     95       		*/	MARK_null,	
/*150     96       		*/	MARK_null,
/*151     97       		*/	MARK_null,
/*152     98       		*/	MARK_null,
/*153     99       		*/	MARK_null,	
/*154     9A       		*/	MARK_null,
/*155     9B      		*/	MARK_null,
/*156     9C      		*/	MARK_null,
/*157     9D      		*/	MARK_null,	
/*158     9E      		*/	MARK_null,
/*159     9F       		*/	MARK_null,
/*160     A0      		*/	MARK_null,	/* Blank */
/*161     A1      �		*/	MARK_punct,	/* Inverted exclamation mark */	/* 0xa0 to 0xaf */
/*162     A2      		*/	MARK_null,	/* Cent */
/*163     A3      		*/	MARK_null,	/* Pound */
/*164     A4      		*/	MARK_null,	/* International currency */
/*165     A5      		*/	MARK_null,	/* Yen */
/*166     A6      		*/	MARK_null,	/* Pipe */
/*167     A7      		*/	MARK_null,	/* Section sign */
/*168     A8      		*/	MARK_null,	/* Diaeresis */
/*169     A9       		*/	MARK_null,	/* Copyright */	
/*170     AA      		*/	MARK_null,	/* Feminine number ordinalizer */
/*171     AB      		*/	MARK_null,	/* Left pointing guiellmets */
/*172     AC      		*/	MARK_null,	/* Logical not */
/*173     AD      		*/	MARK_null,	/* Hyphen */	
/*174     AE      		*/	MARK_null,	/* Registered sign */
/*175     AF      		*/	MARK_null,	/* Macron symbol */
/*176     B0  			*/	MARK_null,	/* Ring (Degree) */
/*177     B1      		*/	MARK_null,	/* Plus/minus */				/* 0xb0 to 0xbf */	
/*178     B2      		*/	MARK_digit,	/* Superscipt 2 */
/*179     B3      		*/	MARK_digit,	/* Superscipt 3 */
/*180     B4      		*/	MARK_null,	/* Accent accute */
/*181     B5      		*/	MARK_null,	/* Micro */
/*182     B6      		*/	MARK_null,	/* Paragraph sign */
/*183     B7      		*/	MARK_punct,	/* Centered dot */
/*184     B8      		*/	MARK_null,	/* Cedilla */
/*185     B9      		*/	MARK_digit,	/* Superscript 1 */
/*186     BA      		*/	MARK_null,	/* Masculine number ordinalizer */
/*187     BB      		*/	MARK_null,	/* Left pointing guiellmets */
/*188     BC      		*/	MARK_digit,	/* Fraction one fourth */
/*189     BD      		*/	MARK_digit,	/* Fraction one half */
/*190     BE     		*/	MARK_digit,	/* Fraction three-fourths */
/*191     BF     		*/	MARK_punct,	/* Inverted question mark */
/*192     C0     		*/	MARK_upper+MARK_vowel,	/* Grave accent on capital A */
/*193     C1     		*/	MARK_upper+MARK_vowel,	/* Acute accent on capital A */	/* 0xc0 to 0xcf */
/*194     C2     		*/	MARK_upper+MARK_vowel,	/* Circumflex accent on capital A */
/*195     C3     		*/	MARK_upper+MARK_vowel,	/* Tilde accent on capital A */
/*196     C4     		*/	MARK_upper+MARK_vowel,	/* Umlaut or diaresis accent on capital A */
/*197     C5     		*/	MARK_upper+MARK_vowel,	/* Ring accent on capital A */
/*198     C6     		*/	MARK_upper+MARK_vowel,	/* Dipthong A-E ligature */
/*199     C7     		*/	MARK_upper+MARK_cons,	/* Cedilla accent on capital C */
/*200     C8     		*/	MARK_upper+MARK_vowel,	/* Grave accent on capital E */
/*201     C9     		*/	MARK_upper+MARK_vowel,	/* Acute accent on capital E */
/*202     CA     		*/	MARK_upper+MARK_vowel,	/* Circumflex accent on capital E */
/*203     CB     		*/	MARK_upper+MARK_vowel,	/* Umlaut or diaresis accent on capital E */
/*204     CC     		*/	MARK_upper+MARK_vowel,	/* Grave accent on capital I */
/*205     CD     		*/	MARK_upper+MARK_vowel,	/* Acute accent on capital I */
/*206     CE     		*/	MARK_upper+MARK_vowel,	/* Circumflex accent on capital I */
/*207     CF     		*/	MARK_upper+MARK_vowel,	/* Umlaut or diaresis accent on capital I */
/*208     D0     		*/	MARK_upper+MARK_cons,	/* Upper case ETH */
/*209     D1     		*/	MARK_upper+MARK_cons,	/* Tilde accent on capital N */	/* 0xd0 to 0xdf */
/*210     D2     		*/	MARK_upper+MARK_vowel,	/* Grave accent on capital O */
/*211     D3     		*/	MARK_upper+MARK_vowel,	/* Acute accent on capital O */
/*212     D4     		*/	MARK_upper+MARK_vowel,	/* Circumflex accent on capital O */
/*213     D5     		*/	MARK_upper+MARK_vowel,	/* Tilde accent on capital O */
/*214     D6     		*/	MARK_upper+MARK_vowel,	/* Umlaut or diaresis accent on capital O */
/*215     D7     		*/	MARK_null,	/* Multiply */
/*216     D8     		*/	MARK_upper+MARK_vowel,	/* Upper case O oblique */
/*217     D9     		*/	MARK_upper+MARK_vowel,	/* Grave accent on capital U */
/*218     DA     		*/	MARK_upper+MARK_vowel,	/* Acute accent on capital U */
/*219     DB     		*/	MARK_upper+MARK_vowel,	/* Circumflex accent on capital U */
/*220     DC     		*/	MARK_upper+MARK_vowel,	/* Umlaut or diaresis accent on capital U */
/*221     DD     		*/	MARK_upper+MARK_vowel+MARK_cons,	/* Accute accent on capital Y */
/*222     DE     		*/	MARK_upper,	/* Uppercase thorn */
/*223     DF                    */      MARK_cons,      /* Lowercase es zet ligature */
/*224     E0     		*/	MARK_vowel,	/* Grave accent on lowercase a */
/*225     E1     		*/	MARK_vowel,	/* Acute accent on lowercase a */	/* 0xe0 to 0xef */	
/*226     E2     		*/	MARK_vowel,	/* Circumflex accent on lowercase a */
/*227     E3     		*/	MARK_vowel,	/* Tilde accent on lowercase a */
/*228     E4     		*/	MARK_vowel,	/* Umlaut or diaresis accent on lowercase a */
/*229     E5     		*/	MARK_vowel,	/* Ring accent on lowercase a */	
/*230     E6     		*/	MARK_vowel,	/* Lowercase a-e ligature */
/*231     E7     		*/	MARK_cons,	/* Cedilla accent on lowercase c */			
/*232     E8     		*/	MARK_vowel,	/* Grave accent on lowercase e */
/*233     E9     		*/	MARK_vowel,	/* Acute accent on lowercase e */			
/*234     EA     		*/	MARK_vowel,	/* Circumflex accent on lowercase e */
/*235     EB     		*/	MARK_vowel,	/* Umlaut or diaresis accent on lowercase e */
/*236     EC     		*/	MARK_vowel,	/* Grave accent on lowercase i */
/*237     ED     		*/	MARK_vowel,	/* Acute accent on lowercase i */
/*238     EE     		*/	MARK_vowel,	/* Circumflex accent on lowercase i */
/*239     EF     		*/	MARK_vowel,	/* Umlaut or diaresis accent on lowercase i */	
/*240     F0     		*/	MARK_cons,	/* Lower case eth */
/*241     F1     		*/	MARK_cons,	/* Tilde accent on lowercase n */	/* 0xf0 to 0xff */
/*242     F2     		*/	MARK_vowel,	/* Grave accent on lowercase o */
/*243     F3     		*/	MARK_vowel,	/* Acute accent on lowercase o */			
/*244     F4     		*/	MARK_vowel,	/* Circumflex accent on lowercase o */
/*245     F5     		*/	MARK_vowel,	/* Tilde accent on lowercase o */			
/*246     F6     		*/	MARK_vowel,	/* Umlaut or diaresis accent on lowercase o */
/*247     F7     		*/	MARK_null,	/* Divide by */		
/*248     F8     		*/	MARK_vowel,	/* Slash accent on lowercase o */
/*249     F9     		*/	MARK_vowel,	/* Grave accent on lowercase u */			
/*250     FA     		*/	MARK_vowel,	/* Acute accent on lowercase u */
/*251     FB     		*/	MARK_vowel,	/* Circumflex accent on lowercase u */	
/*252     FC     		*/	MARK_vowel,	/* Umlaut or diaresis accent on lowercase u */
/*253     FD     		*/	MARK_vowel+MARK_cons,	/* Accute accent on lowercase y */			
/*254     FE     		*/	MARK_null,	/* Lower case thorn */
/*255     FF     		*/	MARK_vowel+MARK_cons,	/* Umlaut or diaresis accent on lowercase y */	
/*				*/	MARK_null,
/*				*/	MARK_null,
};

#ifdef VOCAL
/* SIK 10/10/96 Added old nchar_TYPE2s table to work with VOCAL code */ 
unsigned int nchar_types[]= {

/* dec    hex     printable  char          non-printable char   */
/* num    num     char       TYPE2          description          */
/*                                                              */
/*  0     00      nul	*/	TYPE2_null+TYPE2_number,                                          
/*  1     01      soh	*/	TYPE2_null,			/* 0x00 to 0x0f */
/*  2     02      stx	*/	TYPE2_null,
/*  3     03      etx	*/	TYPE2_null,
/*  4     04      eot	*/	TYPE2_null,
/*  5     05      enq	*/	TYPE2_null,	
/*  6     06      ack	*/	TYPE2_null,
/*  7     07      bel	*/	TYPE2_space,
/*  8     08      bs	*/	TYPE2_space,
/*  9     09      ht	*/	TYPE2_clause,	
/* 10     0A      nl	*/	TYPE2_null+TYPE2_space,
/* 11     0B      vt	*/	TYPE2_null+TYPE2_clause+TYPE2_space,
/* 12     0C      ff	*/	TYPE2_null+TYPE2_space,
/* 13     0D      cr	*/	TYPE2_null+TYPE2_space,	
/* 14     0E      so	*/	TYPE2_null,
/* 15     0F      si	*/	TYPE2_space,
/* 16     10      dle	*/	TYPE2_null,
/* 17     11      dc1	*/	TYPE2_null+TYPE2_number,	/* 0x10 to 0x1f */
/* 18     12      dc2	*/	TYPE2_null,
/* 19     13      dc3	*/	TYPE2_null,
/* 20     14      dc4	*/	TYPE2_null,
/* 21     15      nak	*/	TYPE2_null,	
/* 22     16      syn	*/	TYPE2_null,
/* 23     17      etb	*/	TYPE2_null,
/* 24     18      can	*/	TYPE2_null,
/* 25     19      em	*/	TYPE2_null,	
/* 26     1A      sub	*/	TYPE2_null,
/* 27     1B      esc	*/	TYPE2_null,
/* 28     1C      fs	*/	TYPE2_null,
/* 29     1D      gs	*/	TYPE2_null,	
/* 30     1E      rs	*/	TYPE2_null,
/* 31     1F      us	*/	TYPE2_null,
/* 32     20      sp	*/	TYPE2_space,
/* 33     21      !		*/	TYPE2_punct+TYPE2_clause,	/* 0x20 to 0x2f */
/* 34     22      "		*/	TYPE2_punct,
/* 35     23      #		*/	TYPE2_non_alpha,
/* 36     24      $		*/	TYPE2_cons+TYPE2_number,
/* 37     25      %		*/	TYPE2_non_alpha+TYPE2_number,	/*eab change $ to aloha */
/* 38     26      &		*/	TYPE2_cons,
/* 39     27      '		*/	TYPE2_punct+TYPE2_clause, 	/* change & to equal a cons*/
/* 40     28      (		*/	TYPE2_non_alpha+TYPE2_number,
/* 41     29      )		*/	TYPE2_non_alpha+TYPE2_number,  	
/* 42     2A      *		*/	TYPE2_non_alpha,
/* 43     2B      +		*/	TYPE2_non_alpha+TYPE2_number,
/* 44     2C      ,		*/	TYPE2_punct+TYPE2_clause,
/* 45     2D      -		*/	TYPE2_punct+TYPE2_clause,		
/* 46     2E      .		*/	TYPE2_punct+TYPE2_clause,
/* 47     2F      /		*/	TYPE2_punct+TYPE2_number,
/* 48     30      0		*/	TYPE2_number+TYPE2_digit,
/* 49     31      1		*/	TYPE2_number+TYPE2_digit,			/* 0x30 to 0x3f */
/* 50     32      2		*/	TYPE2_number+TYPE2_digit,
/* 51     33      3		*/	TYPE2_number+TYPE2_digit,
/* 52     34      4		*/	TYPE2_number+TYPE2_digit,
/* 53     35      5		*/	TYPE2_number+TYPE2_digit,
/* 54     36      6		*/	TYPE2_number+TYPE2_digit,
/* 55     37      7		*/	TYPE2_number+TYPE2_digit,
/* 56     38      8		*/	TYPE2_number+TYPE2_digit,
/* 57     39      9		*/	TYPE2_number+TYPE2_digit,
/* 58     3A      :		*/	TYPE2_punct+TYPE2_clause,
/* 59     3B      ;		*/	TYPE2_punct+TYPE2_clause,
/* 60     3C      <		*/	TYPE2_non_alpha,
/* 61     3D      =		*/	TYPE2_non_alpha+TYPE2_number,	
/* 62     3E      >		*/	TYPE2_non_alpha,
/* 63     3F      ?		*/	TYPE2_punct+TYPE2_clause,
/* 64     40      @		*/	TYPE2_non_alpha,
/* 65     41      A		*/	TYPE2_upper+TYPE2_vowel,	/* 0x40 to 0x4f */
/* 66     42      B		*/	TYPE2_upper+TYPE2_cons,
/* 67     43      C		*/	TYPE2_upper+TYPE2_cons,
/* 68     44      D		*/	TYPE2_upper+TYPE2_cons,
/* 69     45      E		*/	TYPE2_upper+TYPE2_vowel,	
/* 70     46      F		*/	TYPE2_upper+TYPE2_cons,
/* 71     47      G		*/	TYPE2_upper+TYPE2_cons,
/* 72     48      H		*/	TYPE2_upper+TYPE2_cons,
/* 73     49      I		*/	TYPE2_upper+TYPE2_vowel,	
/* 74     4A      J		*/	TYPE2_upper+TYPE2_cons,
/* 75     4B      K		*/	TYPE2_upper+TYPE2_cons,
/* 76     4C      L		*/	TYPE2_upper+TYPE2_cons,
/* 77     4D      M		*/	TYPE2_upper+TYPE2_cons,	
/* 78     4E      N		*/	TYPE2_upper+TYPE2_cons,
/* 79     4F      O		*/	TYPE2_upper+TYPE2_vowel,
/* 80     50      P		*/	TYPE2_upper+TYPE2_cons,
/* 81     51      Q		*/	TYPE2_upper+TYPE2_cons,	/* 0x50 to 0x5f */			
/* 82     52      R		*/	TYPE2_upper+TYPE2_cons,
/* 83     53      S		*/	TYPE2_upper+TYPE2_cons,
/* 84     54      T		*/	TYPE2_upper+TYPE2_cons,
/* 85     55      U		*/	TYPE2_upper+TYPE2_vowel,				
/* 86     56      V		*/	TYPE2_upper+TYPE2_cons,
/* 87     57      W		*/	TYPE2_upper+TYPE2_cons,
/* 88     58      X		*/	TYPE2_upper+TYPE2_cons,
/* 89     59      Y		*/	TYPE2_upper+TYPE2_cons+TYPE2_vowel,	
/* 90     5A      Z		*/	TYPE2_upper+TYPE2_cons,
/* 91     5B      [		*/	TYPE2_null,
/* 92     5C      \		*/	TYPE2_punct,
/* 93     5D      ]		*/	TYPE2_non_alpha,						
/* 94     5E      ^		*/	TYPE2_non_alpha,
/* 95     5F      _		*/	TYPE2_null,
/* 96     60      `		*/	TYPE2_non_alpha,
/* 97     61      a		*/	TYPE2_vowel,			/* 0x60 to 0x6f */
/* 98     62      b		*/	TYPE2_cons,
/* 99     63      c		*/	TYPE2_cons,
/*100     64      d		*/	TYPE2_cons,
/*101     65      e		*/	TYPE2_vowel,	
/*102     66      f		*/	TYPE2_cons,
/*103     67      g		*/	TYPE2_cons,
/*104     68      h		*/	TYPE2_cons,
/*105     69      i		*/	TYPE2_vowel,
/*106     6A      j		*/	TYPE2_cons,
/*107     6B      k		*/	TYPE2_cons,
/*108     6C      l		*/	TYPE2_cons,
/*109     6D      m		*/	TYPE2_cons,
/*110     6E      n		*/	TYPE2_cons,
/*111     6F      o		*/	TYPE2_vowel,
/*112     70      p		*/	TYPE2_cons,
/*113     71      q		*/	TYPE2_cons,			/* 0x70 to 0x7f */
/*114     72      r		*/	TYPE2_cons,
/*115     73      s		*/	TYPE2_cons,
/*116     74      t		*/	TYPE2_cons,
/*117     75      u		*/	TYPE2_vowel,					
/*118     76      v		*/	TYPE2_cons,
/*119     77      w		*/	TYPE2_cons,
/*120     78      x		*/	TYPE2_cons,
/*121     79      y		*/	TYPE2_cons+TYPE2_vowel,	
/*122     7A      z		*/	TYPE2_cons,
/*123     7B      {		*/	TYPE2_non_alpha,
/*124     7C      |		*/	TYPE2_non_alpha,
/*125     7D      }		*/	TYPE2_non_alpha,			
/*126     7E      ~		*/	TYPE2_non_alpha,
/*127     7F      		*/	TYPE2_null,
/*128     80       		*/	TYPE2_null,
/*129     81       		*/	TYPE2_null,			/* 0x80 to 0x8f */	
/*130     82       		*/	TYPE2_null,
/*131     83       		*/	TYPE2_null,
/*132     84       		*/	TYPE2_null,
/*133     85       		*/	TYPE2_null,	
/*134     86       		*/	TYPE2_null,
/*135     87       		*/	TYPE2_null,
/*136     88       		*/	TYPE2_null,
/*137     89        	*/	TYPE2_null,	
/*138     8A       		*/	TYPE2_null,
/*139     8B       		*/	TYPE2_null,
/*140     8C       		*/	TYPE2_null,
/*141     8D       		*/	TYPE2_null,	
/*142     8E       		*/	TYPE2_null,
/*143     8F       		*/	TYPE2_null,
/*144     90       		*/	TYPE2_null,
/*145     91       		*/	TYPE2_null,			/* 0x90 to 0x9f */
/*146     92       		*/	TYPE2_null,
/*147     93       		*/	TYPE2_null,
/*148     94       		*/	TYPE2_null,
/*149     95       		*/	TYPE2_null,	
/*150     96       		*/	TYPE2_null,
/*151     97       		*/	TYPE2_null,
/*152     98       		*/	TYPE2_null,
/*153     99       		*/	TYPE2_null,	
/*154     9A       		*/	TYPE2_null,
/*155     9B      		*/	TYPE2_null,
/*156     9C      		*/	TYPE2_null,
/*157     9D      		*/	TYPE2_null,	
/*158     9E      		*/	TYPE2_null,
/*159     9F       		*/	TYPE2_null,
/*160     A0      		*/	TYPE2_null,	/* Blank */
/*161     A1      �		*/	TYPE2_null,	/* Inverted exclamation TYPE2 */	/* 0xa0 to 0xaf */
/*162     A2      		*/	TYPE2_null,	/* Cent */
/*163     A3      		*/	TYPE2_null,	/* Pound */
/*164     A4      		*/	TYPE2_null,	/* International currency */
/*165     A5      		*/	TYPE2_null,	/* Yen */
/*166     A6      		*/	TYPE2_null,	/* Pipe */
/*167     A7      		*/	TYPE2_null,	/* Section sign */
/*168     A8      		*/	TYPE2_null,	/* Diaeresis */
/*169     A9       		*/	TYPE2_null,	/* Copyright */	
/*170     AA      		*/	TYPE2_null,	/* Feminine number ordinalizer */
/*171     AB      		*/	TYPE2_null,	/* Left pointing guiellmets */
/*172     AC      		*/	TYPE2_null,	/* Logical not */
/*173     AD      		*/	TYPE2_null,	/* Hyphen */	
/*174     AE      		*/	TYPE2_null,	/* Registered sign */
/*175     AF      		*/	TYPE2_null,	/* Macron symbol */
/*176     B0  			*/	TYPE2_null,	/* Ring (Degree) */
/*177     B1      		*/	TYPE2_null,	/* Plus/minus */			/* 0xb0 to 0xbf */	
/*178     B2      		*/	TYPE2_number,	/* Superscipt 2 */
/*179     B3      		*/	TYPE2_number,	/* Superscipt 3 */
/*180     B4      		*/	TYPE2_null,	/* Accent accute */
/*181     B5      		*/	TYPE2_null,	/* Micro */
/*182     B6      		*/	TYPE2_null,	/* Paragraph sign */
/*183     B7      		*/	TYPE2_null,	/* Centered dot */
/*184     B8      		*/	TYPE2_null,	/* Cedilla */
/*185     B9      		*/	TYPE2_number,	/* Superscript 1 */
/*186     BA      		*/	TYPE2_null,	/* Masculine number ordinalizer */
/*187     BB      		*/	TYPE2_null,	/* Left pointing guiellmets */
/*188     BC      		*/	TYPE2_number,	/* Fraction one fourth */
/*189     BD      		*/	TYPE2_number,	/* Fraction one half */
/*190     BE     		*/	TYPE2_number,	/* Fraction three-fourths */
/*191     BF     		*/	TYPE2_null,	/* Inverted question TYPE2 */
/*192     C0     		*/	TYPE2_upper+TYPE2_vowel,	/* Grave accent on capital A */
/*193     C1     		*/	TYPE2_upper+TYPE2_vowel,	/* Acute accent on capital A */	/* 0xc0 to 0xcf */
/*194     C2     		*/	TYPE2_upper+TYPE2_vowel,	/* Circumflex accent on capital A */
/*195     C3     		*/	TYPE2_upper+TYPE2_vowel,	/* Tilde accent on capital A */
/*196     C4     		*/	TYPE2_upper+TYPE2_vowel,	/* Umlaut or diaresis accent on capital A */
/*197     C5     		*/	TYPE2_upper+TYPE2_vowel,	/* Ring accent on capital A */
/*198     C6     		*/	TYPE2_upper+TYPE2_vowel,	/* Dipthong A-E ligature */
/*199     C7     		*/	TYPE2_upper+TYPE2_cons,	/* Cedilla accent on capital C */
/*200     C8     		*/	TYPE2_upper+TYPE2_vowel,	/* Grave accent on capital E */
/*201     C9     		*/	TYPE2_upper+TYPE2_vowel,	/* Acute accent on capital E */
/*202     CA     		*/	TYPE2_upper+TYPE2_vowel,	/* Circumflex accent on capital E */
/*203     CB     		*/	TYPE2_upper+TYPE2_vowel,	/* Umlaut or diaresis accent on capital E */
/*204     CC     		*/	TYPE2_upper+TYPE2_vowel,	/* Grave accent on capital I */
/*205     CD     		*/	TYPE2_upper+TYPE2_vowel,	/* Acute accent on capital I */
/*206     CE     		*/	TYPE2_upper+TYPE2_vowel,	/* Circumflex accent on capital I */
/*207     CF     		*/	TYPE2_upper+TYPE2_vowel,	/* Umlaut or diaresis accent on capital I */
/*208     D0     		*/	TYPE2_upper+TYPE2_cons,	/* Upper case ETH */
/*209     D1     		*/	TYPE2_upper+TYPE2_cons,	/* Tilde accent on capital N */	/* 0xd0 to 0xdf */
/*210     D2     		*/	TYPE2_upper+TYPE2_vowel,	/* Grave accent on capital O */
/*211     D3     		*/	TYPE2_upper+TYPE2_vowel,	/* Acute accent on capital O */
/*212     D4     		*/	TYPE2_upper+TYPE2_vowel,	/* Circumflex accent on capital O */
/*213     D5     		*/	TYPE2_upper+TYPE2_vowel,	/* Tilde accent on capital O */
/*214     D6     		*/	TYPE2_upper+TYPE2_vowel,	/* Umlaut or diaresis accent on capital O */
/*215     D7     		*/	TYPE2_null,	/* Multiply */
/*216     D8     		*/	TYPE2_upper+TYPE2_vowel,	/* Upper case O oblique */
/*217     D9     		*/	TYPE2_upper+TYPE2_vowel,	/* Grave accent on capital U */
/*218     DA     		*/	TYPE2_upper+TYPE2_vowel,	/* Acute accent on capital U */
/*219     DB     		*/	TYPE2_upper+TYPE2_vowel,	/* Circumflex accent on capital U */
/*220     DC     		*/	TYPE2_upper+TYPE2_vowel,	/* Umlaut or diaresis accent on capital U */
/*221     DD     		*/	TYPE2_upper+TYPE2_vowel+TYPE2_cons,	/* Accute accent on capital Y */
/*222     DE     		*/	TYPE2_upper,	/* Uppercase thorn */
/*223     DF                    */      TYPE2_cons,      /* Lowercase es zet ligature */
/*224     E0     		*/	TYPE2_vowel,	/* Grave accent on lowercase a */
/*225     E1     		*/	TYPE2_vowel,	/* Acute accent on lowercase a */	/* 0xe0 to 0xef */	
/*226     E2     		*/	TYPE2_vowel,	/* Circumflex accent on lowercase a */
/*227     E3     		*/	TYPE2_vowel,	/* Tilde accent on lowercase a */
/*228     E4     		*/	TYPE2_vowel,	/* Umlaut or diaresis accent on lowercase a */
/*229     E5     		*/	TYPE2_vowel,	/* Ring accent on lowercase a */	
/*230     E6     		*/	TYPE2_vowel,	/* Lowercase a-e ligature */
/*231     E7     		*/	TYPE2_cons,	/* Cedilla accent on lowercase c */			
/*232     E8     		*/	TYPE2_vowel,	/* Grave accent on lowercase e */
/*233     E9     		*/	TYPE2_vowel,	/* Acute accent on lowercase e */			
/*234     EA     		*/	TYPE2_vowel,	/* Circumflex accent on lowercase e */
/*235     EB     		*/	TYPE2_vowel,	/* Umlaut or diaresis accent on lowercase e */
/*236     EC     		*/	TYPE2_vowel,	/* Grave accent on lowercase i */
/*237     ED     		*/	TYPE2_vowel,	/* Acute accent on lowercase i */
/*238     EE     		*/	TYPE2_vowel,	/* Circumflex accent on lowercase i */
/*239     EF     		*/	TYPE2_vowel,	/* Umlaut or diaresis accent on lowercase i */	
/*240     F0     		*/	TYPE2_cons,	/* Lower case eth */
/*241     F1     		*/	TYPE2_cons,	/* Tilde accent on lowercase n */	/* 0xf0 to 0xff */
/*242     F2     		*/	TYPE2_vowel,	/* Grave accent on lowercase o */
/*243     F3     		*/	TYPE2_vowel,	/* Acute accent on lowercase o */			
/*244     F4     		*/	TYPE2_vowel,	/* Circumflex accent on lowercase o */
/*245     F5     		*/	TYPE2_vowel,	/* Tilde accent on lowercase o */			
/*246     F6     		*/	TYPE2_vowel,	/* Umlaut or diaresis accent on lowercase o */
/*247     F7     		*/	TYPE2_null,	/* Divide by */		
/*248     F8     		*/	TYPE2_vowel,	/* Slash accent on lowercase o */
/*249     F9     		*/	TYPE2_vowel,	/* Grave accent on lowercase u */			
/*250     FA     		*/	TYPE2_vowel,	/* Acute accent on lowercase u */
/*251     FB     		*/	TYPE2_vowel,	/* Circumflex accent on lowercase u */	
/*252     FC     		*/	TYPE2_vowel,	/* Umlaut or diaresis accent on lowercase u */
/*253     FD     		*/	TYPE2_vowel+TYPE2_cons,	/* Accute accent on lowercase y */			
/*254     FE     		*/	TYPE2_null,	/* Lower case thorn */
/*255     FF     		*/	TYPE2_vowel+TYPE2_cons,	/* Umlaut or diaresis accent on lowercase y */	
/*						*/	TYPE2_null,
/*						*/	TYPE2_null,
}; 
#endif

