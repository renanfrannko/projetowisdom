#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} PRO_META
Exemplo de montagem da modelo e interface para um tabela em MVC

@author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 16/11/2018
@version P1
/*/
//-------------------------------------------------------------------
function pro_meta()  

	Local aTamanho := FWGetDialogSize ( oMainWnd )
	private oJanela 
	
	Define MsDialog oJanela Title 'Controle de Metas Financeiras' From aTamanho[1], aTamanho[2] to aTamanho[3], aTamanho[4] pixel

	oFWLayer := FWLayer():New()
	oFWLayer:Init(oJanela, .F., .T.)
	
	oFwLayer:AddLine('CIMA', 50, .F.) 
	oFWLayer:AddCollumn('PESSOAS', 100, .T., 'CIMA')
		
	oFWLayer:AddLine('BAIXO', 50, .F.) 
	oFWLayer:AddCollumn('METAS' , 100, .T., 'BAIXO')

	oCima := OFWLayer:GetColPanel('PESSOAS', 'CIMA')
	oBaixo := OFWLayer:GetColPanel('METAS', 'BAIXO')
	
	
	// FWMBrowse() - Superior Cabeçalho PESSOAS e METAS
	
	oBCima := FWmBrowse():New()  // Cria um novo browse
	oBCima:SetOwner(oCima)
	oBCima:SetAlias('ZZP') // Define o banco que será utilizado
	oBCima:SetDescription("FATEC ZL | Turma x Aluno") // Descrição do Browse
	oBCima:SetMenuDef( 'pro_meta' )                   // Define de onde virao os botoes deste browse
	oBCima:SetProfileID( '1' )
	
	oBCima:ForceQuitButton()
	oBCima:DisableDetails()
	oBCima:Activate()  // Ativa o Browser
	
	// FWMBrowse() - Superior Direito - Turma x Aluno
	
	oBBaixo := FWmBrowse():New()  // Cria um novo browse
	oBBaixo:SetOwner(oCimaDir)
	oBBaixo:SetAlias('ZZM') // Define o banco que será utilizado
	oBBaixo:SetDescription("METAS por turma ") // Descrição do Browse
	oBBaixo:SetMenuDef( 'pro_meta' )                   // Define de onde virao os botoes deste browse
	oBBaixo:SetProfileID( '2' )
	oBBaixo:DisableDetails()
	
	
	// FWMBrowse() - Inferior  - Notax
	
	oBInf := FWmBrowse():New()  // Cria um novo browse
	oBInf:SetOwner(oBaixo)
	oBInf:SetAlias('ZB7') // Define o banco que será utilizado
//	oBInf:SetDescription("METAS dos METAS ") // Descrição do Browse	
	oBInf:SetMenuDef( 'pro_meta' )                   // Define de onde virao os botoes deste browse
	oBInf:SetProfileID( '3' )
	oBInf:DisableDetails()
	
	oRelacZZM := FWBrwRelation():New()
	oRelacZZM:AddRelation(oBCima, oBBaixo, { { 'ZZM_FILIAL', 'xFilial("ZZM")' }, {'ZZM_CODTUR', 'ZZP_CODTUR'} })
	oRelacZZM:Activate()
	
	oBBaixo:Activate()  // Ativa o Browser
	oBInf:Activate()  // Ativa o Browser

	Activate MsDialog oJanela center

return NIL	
//-------------------------------------------------------------------
	
static function MenuDef()

Local aRotina := {}
Local aRotUser := nil

	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.pro_meta' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"		ACTION 'VIEWDEF.pro_meta' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"		ACTION 'VIEWDEF.pro_meta' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Imprimir"		ACTION 'VIEWDEF.pro_meta' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar"		ACTION 'VIEWDEF.pro_meta' OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"		ACTION 'VIEWDEF.pro_meta' OPERATION 5 ACCESS 0


	If ExistBlock( 'MDpro_meta' ) 	// Verifica se o Model de dados existe 
	
		//                                             Model   Identificador  ID Model
		aRotUser := ExecBlock( 'pro_meta', .F., .F., { NIL,    "MENUDEF",     'pro_meta' } )     // Executa ponto de entrada
		
		If ValType (aRotUser) == "A"   // Confirma se o ponto de entrada é Array
			aEval ( aRotUser, { | aX| aAdd(aRotina, aX) })
		EndIf
	
	EndIf

return aRotina	
//------------------------------------------------------

static function ModelDef()

Local oModelo
Local oStruZZP := FWFormStruct(1, 'ZZP', /*bAvalCampo*/, /*lViewUsado*/ ) 
Local oStruZZM := FWFormStruct(1, 'ZZM', , )

	oModelo := MPFormModel():New( 'MDpro_meta', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ ) 

	oModelo:AddFields('ZZPMaster', /*cOwner*/, oStruZZP/*Estrutura*/, /*bPre */, /*bPost */, /*bLoad */) 
	oModelo:AddGrid('ZZMFilho', 'ZZPMaster', oStruZZM, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
	
	oModelo:SetRelation('ZZMFilho', { { 'ZZM_FILIAL', 'xFilial("ZZM")' }, {'ZZM_IDPES', 'ZZP_IDPES'} }, ZZM->(IndexKey(1))) 
	
	oModelo:GetModel('ZZMFilho'):SetUniqueLine( {'ZZM_IDMETA'})

return oModelo

//-----------------------------------------------------------View do exercício 04---------------------------------------------------
Static Function ViewDef()

	Local oStruZZP := FWFormStruct(2, 'ZZP', )
	Local oStruZZM := FWFormStruct(2, 'ZZM', )
	Local oStruZB7 := FwFormStruct(2, 'ZB7', )
	
	Local oModelo := FWLoadModel('pro_meta')
	
	Local oCalc1 := FWCalcStruct( oModelo:getModel('MEDIA') )
	
	Local oView	

	oView := FWFormView():New() // Cria view
	oView:setModel( oModelo ) // Model de dados usado

	oView:AddField('VIEW_ZZP', oStruZZP, 'ZZPMaster') // Adiciona FormField e amarra a estrutura de formulário do ModelDEF
	oView:AddGrid('VIEW_ZZM', oStruZZM, 'ZZMFilho') 
	oView:AddGrid('VIEW_ZB7', oStruZB7, 'ZB7Filho') 
	
	oView:AddField('VIEW_MEDIA', oCalc1, 'MEDIA')
	
	oView:CreateVerticalBox('TELA_1', 20) // Cria tela horizontal e define o espaço de tela usado %
	oView:CreateVerticalBox('TELA_2', 40) // Cria tela horizontal e define o espaço de tela usado %
	oView:CreateVerticalBox('TELA_3', 40) // Cria tela horizontal e define o espaço de tela usado %
	
	oView:setOwnerView('VIEW_ZZP', 'TELA_1') // Associa o FormField a tela definida acima
	oView:setOwnerView('VIEW_ZZM', 'TELA_2') // Associa o FormField a tela definida acima
	oView:setOwnerView('VIEW_ZB7', 'TELA_3') // Associa o FormField a tela definida acima

	oView:EnableTitleView('VIEW_ZZP','PESSOAS')
	oView:EnableTitleView('VIEW_ZZM','METAS')
	oView:EnableTitleView('VIEW_ZB7','METAS')
	oView:EnableTitleView('VIEW_MEDIA','Média das METAS')
	
	

	
Return oView
	
	



