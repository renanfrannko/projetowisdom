#include 'protheus.ch'
#include 'report.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} REL_DEP
Relat�rio de Listagem de Despesas cadastradas, feito em TReport
Visualiza��o � feito com quebra por Pessoas
 @author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 19/11/2018
@version P1
/*/
//-------------------------------------------------------------------

Function REL_DESP2()
	Local oReport
	Local oZZP
	Local oZZD	

    Pergunte("ZZP001",.F.) 

    DEFINE REPORT oReport NAME "Listagem de Despesas" TITLE "Rela��o de Despesas Cadastradas por Pessoas" PARAMETER "ZZP001"; 
       ACTION {|oReport| PrintReport(oReport)}

	DEFINE SECTION oZZP OF oReport TITLE "Pessoa" TABLE "ZZP" // TOTAL IN COLUMN // PAGE HEADER

		DEFINE CELL NAME "ZZP_IDPES" OF oZZP ALIAS "ZZP"
		DEFINE CELL NAME "ZZP_NOME"  OF oZZP ALIAS "ZZP"


	DEFINE SECTION oZZD OF oZZP TITLE "Despesa" TABLE "ZZD"

	DEFINE CELL NAME "DESPESA" OF oZZD title "DETALHES DAS DESPESAS >" SIZE 10
	
        DEFINE CELL NAME "ZZD_NCAT"   OF oZZD ALIAS "ZZD"
        DEFINE CELL NAME "ZZD_DATA"   OF oZZD ALIAS "ZZD"                             
        DEFINE CELL NAME "ZZD_VALOR"  OF oZZD ALIAS "ZZD"

	oReport:HideParamPage()
	oReport:PrintDialog()

Return

Static Function PrintReport(oReport)
	Local cAlias := ""
		
	#IFDEF TOP  // S� passa por esse trecho quem est� utilizando banco de dados
		cAlias := GetNextAlias()  //   Criar uma tabela tempor�ria.
					
		MakeSqlEXP("ZZP001")

	BEGIN REPORT QUERY oReport:Section(1)

	BeginSQL alias cAlias

		SELECT ZZP.ZZP_IDPES, ZZP.ZZP_NOME,
		ZZD.ZZD_NCAT, SUM(ZZD.ZZD_VALOR) AS 'Total'
		FROM %table:ZZP% ZZP, %table:ZZD% ZZD
		WHERE ZZD.%notDel% AND ZZD_IDPES = ZZP_IDPES
		GROUP BY ZZD_NCAT, ZZP_IDPES, ZZP_NOME
		ORDER BY ZZD_NCAT
		
	EndSql

	END REPORT QUERY oReport:Section(1)

	oReport:Section(1):Section(1):SetParentQuery()
	oReport:Section(1):Section(1):SetParentFilter( { |cParam|  (cAlias)->ZZP_IDPES == cParam }, { || (cAlias)-> ZZP_IDPES })

	oReport:Section(1):Print()

	#ENDIF
Return