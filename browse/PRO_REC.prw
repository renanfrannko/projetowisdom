#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'


//-------------------------------------------------------------------
/*/{Protheus.doc} PRO_REC ---- teste git
Exemplo de montagem da modelo e interface para um tabela em MVC

@author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 16/11/2018
@version P1
/*/
//-------------------------------------------------------------------



Function PRO_REC()
	Local oBrowse
	
	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias( 'ZZX' )
	oBrowse:SetDescription( 'Controle de Receita Pessoal' )
	oBrowse:Activate()

Return NIL

Static Function MenuDef()

	Local aRotina := {}
	
	ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.PRO_REC' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.PRO_REC' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.PRO_REC' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.PRO_REC' OPERATION 5 ACCESS 0
	ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.PRO_REC' OPERATION 8 ACCESS 0
	ADD OPTION aRotina Title 'Copiar'     Action 'VIEWDEF.PRO_REC' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
	
	Local oStruZZX := FWFormStruct( 1, 'ZZX', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oStruZZR := FWFormStruct( 1, 'ZZR', /*bAvalCampo*/, /*lViewUsado*/ )
//	Local oStruZZD := FWFormStruct( 1, 'ZZD', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oModel
	
	oModel := MPFormModel():New( 'RECEITA', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	
	oModel:AddFields( 'ZZXMASTER', /*cOwner*/, oStruZZX )
	
	oModel:AddGrid( 'ZZRDETAIL', 'ZZXMASTER', oStruZZR, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
	
//	oModel:AddGrid( 'ZZDDETAIL', 'ZZXMASTER', oStruZZD, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	oModel:AddCalc( 'TOTALREC', 'ZZXMASTER', 'ZZRDETAIL', 'ZZR_VALOR', 'ZZR__TOTAL', 'SUM',,,'Total Receitas')
	
	oModel:SetRelation( 'ZZRDETAIL', { { 'ZZR_FILIAL', 'xFilial( "ZZR" )' },{ 'ZZR_IDPES' , 'ZZX_IDPES'  } } , ZZR->( IndexKey( 2 ) )  )
	
//	oModel:SetRelation( 'ZZDDETAIL', { { 'ZZD_FILIAL', 'xFilial( "ZZD" )' },{ 'ZZD_IDPES' , 'ZZX_IDPES'  } } , ZZR->( IndexKey( 2 ) )  )
	
	
	oModel:SetDescription( 'Modelo de Controle Financeiro Pessoal' )
	
	oModel:GetModel( 'ZZXMASTER' ):SetDescription( 'Dados da Pessoa' )
	oModel:GetModel( 'ZZRDETAIL' ):SetDescription( 'Dados das Receitas'  )
//	oModel:GetModel( 'ZZDDETAIL' ):SetDescription( 'Dados das Despeas'  )
	
	

Return oModel


Static Function ViewDef()

	Local oStruZZX := FWFormStruct( 2, 'ZZX' )
	Local oStruZZR := FWFormStruct( 2, 'ZZR' )
//	Local oStruZZD := FWFormStruct( 2, 'ZZD' )

	Local oModel   := FWLoadModel( 'PRO_REC' )
	Local oView
	
	oView := FWFormView():New()
	
	oView:SetModel( oModel )
	
	oView:AddField( 'VIEW_ZZX', oStruZZX, 'ZZXMASTER' )
	
	oView:AddGrid(  'VIEW_ZZR', oStruZZR, 'ZZRDETAIL' )
//	oView:AddGrid(  'VIEW_ZZD', oStruZZD, 'ZZDDETAIL' )

	oCalc1 := FWCalcStruct( oModel:GetModel( 'TOTALREC') )
	
	oView:AddField( 'VIEW_CALC', oCalc1, 'TOTALREC' )
	
	
	oView:CreateHorizontalBox( 'EMCIMA' , 15 )
	oView:CreateHorizontalBox( 'MEIO'   , 70 )
	oView:CreateHorizontalBox( 'EMBAIXO', 15 )
	
	oView:SetOwnerView( 'VIEW_ZZX', 'EMCIMA'   )
	oView:SetOwnerView( 'VIEW_ZZR', 'MEIO'     )
//	oView:SetOwnerView( 'VIEW_ZZD', 'EMBAIXO'  )
	oView:SetOwnerView( 'VIEW_CALC', 'EMBAIXO' )
	
	oView:EnableTitleView( 'VIEW_ZZX', "Pessoa" )
	oView:EnableTitleView( 'VIEW_ZZR', "Receitas" )
//	oView:EnableTitleView( 'VIEW_ZZD', "Despesas" )
	
Return oView

//-------------------------------------------------------------------

