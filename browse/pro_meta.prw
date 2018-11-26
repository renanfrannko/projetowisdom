#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} PRO_META
Interface para inclusão de metas financeiras por período mensal

@author RENAN FRANCO
@since 16/11/2018
@version P1
/*/
//-------------------------------------------------------------------

//-------------------------------------------------------------------
function pro_meta()

	Local oBrowse

	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias( 'ZZM' )
	oBrowse:SetDescription( 'Wisdom | Metas mensais' )
	oBrowse:Activate()

return NIL

//-------------------------------------------------------------------
static function MenuDef()

	Local aRotina := {}
	Local aRotUser := nil

	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'VIEWDEF.pro_meta' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"		ACTION 'VIEWDEF.pro_meta' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"		ACTION 'VIEWDEF.pro_meta' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"		ACTION 'VIEWDEF.pro_meta' OPERATION 5 ACCESS 0

	If ExistBlock( 'MDpro_meta' ) 	// Verifica se o Model de dados existe

		//                                             Model   Identificador  ID Model
		aRotUser := ExecBlock( 'pro_meta', .F., .F., { NIL,    "MENUDEF",     'pro_meta' } )     // Executa ponto de entrada

		If ValType (aRotUser) == "A"   // Confirma se o ponto de entrada � Array
			aEval ( aRotUser, { | aX| aAdd(aRotina, aX) })
		EndIf

	EndIf

return aRotina

//-------------------------------------------------------------------
static function ModelDef()

	Local oModelo
	Local oStruZZM := FWFormStruct(1, 'ZZM', , )

	oModelo := MPFormModel():New( 'MDpro_meta', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	oModelo:AddFields('ZZMMaster', /*cOwner*/, oStruZZM/*Estrutura*/, /*bPre */, /*bPost */, /*bLoad */)
  oModelo:SetDescription( 'Wisdom | Metas mensais' )


return oModelo

//-------------------------------------------------------------------
Static Function ViewDef()

	Local oStruZZM := FWFormStruct(2, 'ZZM', )
	Local oModelo := FWLoadModel('pro_meta')
	Local oView

	oView := FWFormView():New() // Cria view
	oView:setModel( oModelo ) // Model de dados usado

	oView:AddField('VIEW_ZZM', oStruZZM, 'ZZMMaster')

	oView:CreateHorizontalBox('TELA_1', 100) 
	oView:setOwnerView('VIEW_ZZM', 'TELA_1') 
	oView:EnableTitleView('VIEW_ZZM','METAS')
	oView:EnableControlBar(.T.)

Return oView

//-------------------------------------------------------------------

