#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} PRO_PES
Exemplo de montagem da modelo e interface para um tabela em MVC

@author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 16/11/2018
@version P1
/*/
//-------------------------------------------------------------------

Function PRO_PES()
	Local oBrowse
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZZP')
	oBrowse:SetDescription('Cadastro de Pessoa')
	
	oBrowse:Activate()

Return NIL
//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.PRO_PES' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.PRO_PES' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.PRO_PES' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.PRO_PES' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.PRO_PES' OPERATION 8 ACCESS 0

Return aRotina
//-------------------------------------------------------------------
Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZZP := FWFormStruct( 1, 'ZZP', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('PESSOA', /*bPreValidacao*/,  , , /*bCancel*/ )
	
	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZZPMASTER', /*cOwner*/, oStruZZP, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	
	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Modelo de Pessoa' )
	
	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZZPMASTER' ):SetDescription( 'Dados de Pessoa' )
	
	oModel:SetVldActivate( { |oModel| PodeAtivar( oModel ) } )

Return oModel
//-------------------------------------------------------------------
Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	// Cria a estrutura a ser usada na View
	Local oModel   := FWLoadModel( 'PRO_PES' )
	Local oStruZZP := FWFormStruct( 2, 'ZZP' )
	Local oView
	Local cCampos := {}

	// Cria o objeto de View
	oView := FWFormView():New()
	
	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )
	
	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZZP', oStruZZP, 'ZZPMASTER' )
	
	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )
	
	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZZP', 'TELA' )
	 

Return oView

//------------------------------------------------------------------------

Static function PodeAtivar( oModel )  
	
	Local aArea      := GetArea()
	Local cQuery     := ''
	Local cTmp       := ''
	Local lRet       := .T.
	Local nOperation := oModel:GetOperation()
	
	If nOperation == MODEL_OPERATION_DELETE .AND. lRet
		
		cTmp    := GetNextAlias()
		
		cQuery  := ""
		cQuery  += "SELECT ZZP_IDPES FROM " + RetSqlName( 'ZZP' ) + " ZZP "
		cQuery  += " WHERE EXISTS ( "
		cQuery  += "       (SELECT 1 FROM " + RetSqlName( 'ZZX' ) + " ZZX "
		cQuery  += "        WHERE ZZX_IDPES = ZZP_IDPES"
		cQuery  += "          AND ZZX.D_E_L_E_T_ = ' ' ) "
		cQuery  += "        UNION "
		cQuery  += "       (SELECT 1 FROM " + RetSqlName( 'ZZY' ) + " ZZY "
		cQuery  += "        WHERE ZZY_IDPES = ZZP_IDPES"
		cQuery  += "          AND ZZY.D_E_L_E_T_ = ' ' ) )"
		cQuery  += "   AND ZZP_IDPES = '" + ZZP->ZZP_IDPES  + "' "
		cQuery  += "   AND ZZP.D_E_L_E_T_ = ' ' "

 				
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )
		
		lRet := (cTmp)->( EOF() )
		
		(cTmp)->( dbCloseArea() )
		
		If lRet
		cQuery  := ""
		cQuery  += "SELECT ZZP_IDPES FROM " + RetSqlName( 'ZZP' ) + " ZZP "
		cQuery  += " WHERE EXISTS ( "
		cQuery  += "       (SELECT 1 FROM " + RetSqlName( 'ZZX' ) + " ZZX "
		cQuery  += "        WHERE ZZX_IDPES = ZZP_IDPES"
		cQuery  += "          AND ZZX.D_E_L_E_T_ = ' ' ) "
		cQuery  += "        UNION "
		cQuery  += "       (SELECT 1 FROM " + RetSqlName( 'ZZY' ) + " ZZY "
		cQuery  += "        WHERE ZZY_IDPES = ZZP_IDPES"
		cQuery  += "          AND ZZY.D_E_L_E_T_ = ' ' ) )"
		cQuery  += "   AND ZZP_IDPES = '" + ZZP->ZZP_IDPES  + "' "
		cQuery  += "   AND ZZP.D_E_L_E_T_ = ' ' "
					
			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )
			
			lRet := (cTmp)->( EOF() )
			
			(cTmp)->( dbCloseArea() )
			
		EndIf
		
		If !lRet
			Help( ,, 'HELP',, 'Esta Pessoa não pode ser excluido.', 1, 0)
		EndIf
		
	EndIf
	
	RestArea( aArea )

Return lRet
