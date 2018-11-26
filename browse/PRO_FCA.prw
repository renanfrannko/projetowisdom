#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'


//-------------------------------------------------------------------
/*/{Protheus.doc} PRO_FCA ---- 
Fluxo de caixa

@author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 16/11/2018
@version P1
/*/
//-------------------------------------------------------------------



Function PRO_FCA()
	Local oBrowse

	
	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias( 'ZZP' )
	oBrowse:SetDescription( 'Controle de Receita Pessoal' )
//	oBrowse:SetFilterDefault(Pergunte('PERIODO', .T.) )
	oBrowse:Activate()
	


Return NIL

Static Function MenuDef()

	Local aRotina := {}
	
	ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.PRO_FCA' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.PRO_FCA' OPERATION 8 ACCESS 0

Return aRotina

Static Function ModelDef()
	
	Local oStruZZP := FWFormStruct( 1, 'ZZP', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oStruZZR := FWFormStruct( 1, 'ZZR', { |x| ALLTRIM(x) $ 'ZZR_IDCAT, ZZR_NCAT, ZZR_DATA, ZZR_VALOR, ZZR_DESCR' }, /*lViewUsado*/ )
	Local oStruZZD := FWFormStruct( 1, 'ZZD', { |x| ALLTRIM(x) $ 'ZZD_IDCAT, ZZD_NCAT, ZZD_DATA, ZZD_VALOR, ZZD_DESCR' }, /*lViewUsado*/ )	
	Local oModel
	

	
	oModel := MPFormModel():New( 'FLUXO', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	
	
	oModel:AddFields( 'ZZPMASTER', /*cOwner*/, oStruZZP )
	
	oModel:AddGrid( 'ZZRDETAIL', 'ZZPMASTER', oStruZZR, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
	
	oModel:AddGrid( 'ZZDDETAIL', 'ZZPMASTER', oStruZZD, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	oModel:AddCalc( 'TOTALREC', 'ZZPMASTER', 'ZZRDETAIL', 'ZZR_VALOR', 'ZZR__TOTAL', 'SUM',,,'Total Receitas')
	oModel:AddCalc( 'TOTALDESP', 'ZZPMASTER', 'ZZDDETAIL', 'ZZD_VALOR', 'ZZD__TOTAL', 'SUM',,,'Total Despesas')
	
 	oModel:AddCalc( 'TOTALFCA', 'ZZPMASTER', 'ZZDDETAIL', 'ZZD_VALOR', 'ZZP__TOTAL', 'FORMULA',,,'Total',;
 		{|oModel| oModel:GetValue("TOTALREC","ZZR__TOTAL")-oModel:GetValue("TOTALDESP","ZZD__TOTAL") })
 	
	oModel:SetRelation( 'ZZRDETAIL', { { 'ZZR_FILIAL', 'xFilial( "ZZR" )' },{ 'ZZR_IDPES' , 'ZZP_IDPES'  } } , ZZR->( IndexKey( 2 ) )  )
	
	oModel:SetRelation( 'ZZDDETAIL', { { 'ZZD_FILIAL', 'xFilial( "ZZD" )' },{ 'ZZD_IDPES' , 'ZZP_IDPES'  } } , ZZD->( IndexKey( 2 ) )  )
	
	
	oModel:SetDescription( 'Modelo de Controle Financeiro Pessoal' )
	
	oModel:GetModel( 'ZZPMASTER' ):SetDescription( 'Dados da Pessoa' )
	oModel:GetModel( 'ZZRDETAIL' ):SetDescription( 'Dados das Receitas'  )
	oModel:GetModel( 'ZZDDETAIL' ):SetDescription( 'Dados das Despeas'  )
	
	oModel:SetVldActivate( { |oModel| PodeAtivar( oModel ) } )
	

Return oModel


Static Function ViewDef()

	Local oStruZZP := FWFormStruct( 2, 'ZZP' )
	Local oStruZZR := FWFormStruct( 2, 'ZZR', { |x| ALLTRIM(x) $ 'ZZR_IDCAT, ZZR_NCAT, ZZR_DATA, ZZR_VALOR, ZZR_DESCR' } )
	Local oStruZZD := FWFormStruct( 2, 'ZZD', { |x| ALLTRIM(x) $ 'ZZD_IDCAT, ZZD_NCAT, ZZD_DATA, ZZD_VALOR, ZZD_DESCR' } )

	Local oModel   := FWLoadModel( 'PRO_FCA' )
	Local oView
	
	oView := FWFormView():New()
	
	oView:SetModel( oModel )
	
	oView:AddField( 'VIEW_ZZP', oStruZZP, 'ZZPMASTER' )
	
	oView:AddGrid(  'VIEW_ZZR', oStruZZR, 'ZZRDETAIL' )
	oView:AddGrid(  'VIEW_ZZD', oStruZZD, 'ZZDDETAIL' )

	oCalc1 := FWCalcStruct( oModel:GetModel( 'TOTALREC') )
	oCalc2 := FWCalcStruct( oModel:GetModel( 'TOTALDESP') )
	oCalc3 := FWCalcStruct( oModel:GetModel( 'TOTALFCA') )
	
	oView:AddField( 'VIEW_CALC1', oCalc1, 'TOTALREC' )
	oView:AddField( 'VIEW_CALC2', oCalc2, 'TOTALDESP' )
	oView:AddField( 'VIEW_CALC3', oCalc3, 'TOTALFCA' )
	
	
	oView:CreateHorizontalBox( 'EMCIMA' , 15 )
	oView:CreateHorizontalBox( 'MEIO'   , 55 )
	oView:CreateHorizontalBox( 'EMBAIXO', 15 )
	oView:CreateHorizontalBox( 'RODAPE', 15 )
	
	oView:CreateVerticalBox( 'MEIO01', 50, 'MEIO' )
	oView:CreateVerticalBox( 'MEIO02', 50, 'MEIO' )
	
	oView:CreateVerticalBox( 'EMBAIXO1', 50, 'EMBAIXO' )
	oView:CreateVerticalBox( 'EMBAIXO2', 50, 'EMBAIXO' )
	
	oView:SetOwnerView( 'VIEW_ZZP', 'EMCIMA'   )
	
	oView:SetOwnerView( 'VIEW_ZZR', 'MEIO01'     )
	oView:SetOwnerView( 'VIEW_ZZD', 'MEIO02'  )
	
	oView:SetOwnerView( 'VIEW_CALC1', 'EMBAIXO1' )
	oView:SetOwnerView( 'VIEW_CALC2', 'EMBAIXO2' )
	
	oView:SetOwnerView( 'VIEW_CALC3', 'RODAPE' )
	
	oView:EnableTitleView( 'VIEW_ZZP', "Pessoa" )
	oView:EnableTitleView( 'VIEW_ZZR', "Receitas" )
	oView:EnableTitleView( 'VIEW_ZZD', "Despesas" )
	
	
	
Return oView

Static function PodeAtivar( oModel )  
	
	Local aArea      := GetArea()
	Local cQuery     := ''
	Local cTmp       := ''
	Local lRet       := .T.
	Local nOperation := oModel:GetOperation()
	
		
		cTmp    := GetNextAlias()
		
		If lRet
		cQuery  := ""
		cQuery  += "SELECT ZZP_IDPES FROM " + RetSqlName( 'ZZP' ) + " ZZP, "
		cQuery  += RetSqlName( 'ZZR' ) + " ZZR, "
		cQuery  += RetSqlName( 'ZZD' ) + " ZZD "	
		cQuery  += " WHERE ZZP_IDPES = ZZR_IDPES "
		cQuery  += "   AND ZZP_IDPES = ZZD_IDPES"
		cQuery  += "   AND ZZP_IDPES = '" + ZZP->ZZP_IDPES  + "' "
		cQuery  += "   AND ZZP.D_E_L_E_T_ = ' ' "
					
			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )
			
			lRet := EMPTY((cTmp)->( EOF() ))
			
			(cTmp)->( dbCloseArea() )
			
		EndIf
		
		If !lRet
			Help( ,, 'HELP',, 'Esta Pessoa não possui Receita ou Despesa Cadastrada.', 1, 0)
			lRet := .F.
		EndIf
		

	
	RestArea( aArea )

Return lRet
