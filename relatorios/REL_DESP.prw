#include 'protheus.ch'
#include 'report.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} REL_DEP
Relatório de Listagem de Despesas cadastradas, feito em TReport
Visualização é feito com quebra por Pessoas
 @author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 19/11/2018
@version P1
/*/
//-------------------------------------------------------------------

Function REL_DESP()
	Local oReport
	Local oZZP
	Local oZZD	

    Pergunte("ZZD001",.T.) 

    DEFINE REPORT oReport NAME "Listagem de Despesas" TITLE "Relação de Despesas Cadastradas por Pessoas" PARAMETER "ZZD001"; 
       ACTION {|oReport| PrintReport(oReport)}

	DEFINE SECTION oZZP OF oReport TITLE "Pessoa" TABLE "ZZP" // TOTAL IN COLUMN // PAGE HEADER

		DEFINE CELL NAME "ZZP_IDPES" OF oZZP ALIAS "ZZP"
		DEFINE CELL NAME "ZZP_NOME"  OF oZZP ALIAS "ZZP"


	DEFINE SECTION oZZD OF oZZP TITLE "Despesa" TABLE "ZZD"

	DEFINE CELL NAME "DESPESA" OF oZZD title "DETALHES DAS DESPESAS >" SIZE 10
	
        DEFINE CELL NAME "ZZD_IDDESP" OF oZZD ALIAS "ZZD"
        DEFINE CELL NAME "ZZD_IDCAT"  OF oZZD ALIAS "ZZD"
        DEFINE CELL NAME "ZZD_NCAT"   OF oZZD ALIAS "ZZD"
        DEFINE CELL NAME "ZZD_DESCR"  OF oZZD ALIAS "ZZD"   
        DEFINE CELL NAME "ZZD_DATA"   OF oZZD ALIAS "ZZD"                             
        DEFINE CELL NAME "ZZD_VALOR"  OF oZZD ALIAS "ZZD"

	oReport:HideParamPage()
	oReport:PrintDialog()

Return

Static Function PrintReport(oReport)
	Local cAlias := ""
		
	#IFDEF TOP  // Só passa por esse trecho quem está utilizando banco de dados
		cAlias := GetNextAlias()  //   Criar uma tabela temporária.
					
		MakeSqlEXP("ZZD001")

	BEGIN REPORT QUERY oReport:Section(1)

	BeginSQL alias cAlias

		SELECT ZZP.ZZP_IDPES, ZZP.ZZP_NOME,
		ZZD.ZZD_IDDESP,ZZD.ZZD_IDCAT,ZZD.ZZD_NCAT,ZZD.ZZD_DESCR,ZZD.ZZD_DATA,ZZD.ZZD_VALOR
		FROM %table:ZZP% ZZP, %table:ZZD% ZZD

		WHERE ZZD.%notDel% AND ZZD_IDPES = ZZP_IDPES

		ORDER BY ZZD_IDDESP

	EndSql

	END REPORT QUERY oReport:Section(1)

	oReport:Section(1):Section(1):SetParentQuery()
	oReport:Section(1):Section(1):SetParentFilter( { |cParam|  (cAlias)->ZZP_IDPES == cParam }, { || (cAlias)-> ZZP_IDPES })

	oReport:Section(1):Print()

	#ENDIF
Return