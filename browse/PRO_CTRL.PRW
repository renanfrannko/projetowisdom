#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'


//-------------------------------------------------------------------
/*/{Protheus.doc} PRO_REC
Exemplo de montagem da modelo e interface para um tabela em MVC

@author BEATRIZ DE SOUZA, LETICIA CAMPOS, MARCIO SANTOS, RENAN FRANCO
@since 16/11/2018
@version P1
/*/
//-------------------------------------------------------------------

Static Function ModelDef()

Return FWLoadModel( 'PRO_REC' )

//-------------------------------------------------------------------

Static Function ViewDef()

Return FWLoadView( 'PRO_REC' )
