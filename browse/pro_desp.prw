#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'


//-------------------------------------------------------------------
/*/{Protheus.doc} PRO_DESP
Exemplo de montagem da modelo e interface para um tabela em MVC

@author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 16/11/2018
@version P1
/*/
//-------------------------------------------------------------------



Function PRO_DESP()
	Local oBrowse
	
	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias( 'ZZY' )
	oBrowse:SetDescription( 'Controle de Despesa Pessoal' )
	oBrowse:Activate()

Return NIL

Static Function MenuDef()

	Local aRotina := {}
	
	ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.PRO_DESP' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.PRO_DESP' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.PRO_DESP' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.PRO_DESP' OPERATION 5 ACCESS 0
	ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.PRO_DESP' OPERATION 8 ACCESS 0
	ADD OPTION aRotina Title 'Copiar'     Action 'VIEWDEF.PRO_DESP' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
	
	Local oStruZZY := FWFormStruct( 1, 'ZZY', /*bAvalCampo*/, /*lViewUsado*/ )
//	Local oStruZZR := FWFormStruct( 1, 'ZZR', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oStruZZD := FWFormStruct( 1, 'ZZD', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oModel
	
	oModel := MPFormModel():New( 'DESPESA', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	
	oModel:AddFields( 'ZZYMASTER', /*cOwner*/, oStruZZY )
	
//	oModel:AddGrid( 'ZZRDETAIL', 'ZZYMASTER', oStruZZR, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
	oModel:AddGrid( 'ZZDDETAIL', 'ZZYMASTER', oStruZZD, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
	
	oModel:AddCalc( 'TOTALDESP', 'ZZYMASTER', 'ZZDDETAIL', 'ZZD_VALOR', 'ZZD__TOTAL', 'SUM',,,'Total Despesas')
	
//	oModel:SetRelation( 'ZZRDETAIL', { { 'ZZR_FILIAL', 'xFilial( "ZZR" )' },{ 'ZZR_IDPES' , 'ZZY_IDPES'  } } , ZZR->( IndexKey( 2 ) )  )	
	oModel:SetRelation( 'ZZDDETAIL', { { 'ZZD_FILIAL', 'xFilial( "ZZD" )' },{ 'ZZD_IDPES' , 'ZZY_IDPES'  } } , ZZR->( IndexKey( 2 ) )  )
	
	
	oModel:SetDescription( 'Modelo de Controle Financeiro Pessoal' )
	
	oModel:GetModel( 'ZZYMASTER' ):SetDescription( 'Dados da Pessoa' )
//	oModel:GetModel( 'ZZRDETAIL' ):SetDescription( 'Dados das Receitas'  )
	oModel:GetModel( 'ZZDDETAIL' ):SetDescription( 'Dados das Despeas'  )
	

Return oModel


Static Function ViewDef()

	Local oStruZZY := FWFormStruct( 2, 'ZZY' )
//	Local oStruZZR := FWFormStruct( 2, 'ZZR' )
	Local oStruZZD := FWFormStruct( 2, 'ZZD' )

	Local oModel   := FWLoadModel( 'PRO_DESP' )
	Local oView
	
	oView := FWFormView():New()
	
	oView:SetModel( oModel )
	
	oView:AddField( 'VIEW_ZZY', oStruZZY, 'ZZYMASTER' )
	
//	oView:AddGrid(  'VIEW_ZZR', oStruZZR, 'ZZRDETAIL' )
	oView:AddGrid(  'VIEW_ZZD', oStruZZD, 'ZZDDETAIL' )
	
	oCalc1 := FWCalcStruct( oModel:GetModel( 'TOTALDESP') )
	
	oView:AddField( 'VIEW_CALC', oCalc1, 'TOTALDESP' )
	
	oView:CreateHorizontalBox( 'EMCIMA' , 15 )
	oView:CreateHorizontalBox( 'MEIO'   , 70 )
	oView:CreateHorizontalBox( 'EMBAIXO', 15 )
	
	oView:SetOwnerView( 'VIEW_ZZY', 'EMCIMA'   )
//	oView:SetOwnerView( 'VIEW_ZZR', 'MEIO'     )
	oView:SetOwnerView( 'VIEW_ZZD', 'MEIO'  )
	oView:SetOwnerView( 'VIEW_CALC', 'EMBAIXO' )
	
	oView:EnableTitleView( 'VIEW_ZZY', "Pessoa" )
//	oView:EnableTitleView( 'VIEW_ZZR', "Receitas" )
	oView:EnableTitleView( 'VIEW_ZZD', "Despesas" )
	
Return oView



