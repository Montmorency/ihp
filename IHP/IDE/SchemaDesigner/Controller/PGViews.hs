module IHP.IDE.SchemaDesigner.Controller.PGViews where

import IHP.ControllerPrelude
import IHP.IDE.ToolServer.Types

import IHP.IDE.SchemaDesigner.View.PGViews.New
--import IHP.IDE.SchemaDesigner.View.PGViews.Show
--import IHP.IDE.SchemaDesigner.View.PGViews.Index
--import IHP.IDE.SchemaDesigner.View.PGViews.Edit

import IHP.IDE.SchemaDesigner.Types
import IHP.IDE.SchemaDesigner.View.Layout (findStatementByName, replace, schemaDesignerLayout)
import qualified IHP.SchemaCompiler as SchemaCompiler
import IHP.IDE.SchemaDesigner.Controller.Helper
import IHP.IDE.SchemaDesigner.Controller.Validation
import IHP.IDE.SchemaDesigner.Controller.Columns (updateForeignKeyConstraint)
import qualified IHP.IDE.SchemaDesigner.SchemaOperations as SchemaOperations


instance Controller PGViewsController where
    beforeAction = setLayout schemaDesignerLayout

    action NewPGViewAction = do
        statements <- readSchema

        let tableNames = statements |> mapMaybe \case
                StatementCreateTable CreateTable { name } -> Just name
                otherwise -> Nothing

        let queryText = case headMay tableNames of
                Just tableName -> "select * from " <> tableName
                otherwise -> "No tables in database: create a table before creating a view."

        render NewPGViewView { .. }

    action CreatePGViewAction = do
        statements <- readSchema
        let pgViewName :: Text = param "pgViewName"
        -- using query as param name because I think the styling requires it
        -- for ACE editor maybe need to fix this in UI?
        let pgViewColumns :: Text = param "columns"
        let pgViewQuery :: Text = param "query"
        let tables = schemaList |> filter (\case
                                                  StatementCreateTable _ -> True
                                                  otherwise -> False
                                          )
        let viewQuery = "CREATE VIEW " <> pgViewName <> " AS\n" <> pgViewQuery
        parseTest $ (runReaderT (parsePGView tables) Map.empty) (cs viewQuery)

        updateSchema (SchemaOperations.addPGView pgViewName pgViewColumns pgViewQuery)
        redirectTo TablesAction

    action DeletePGViewAction { .. } = do
        let pgViewName = param "pgViewName"
        updateSchema (SchemaOperations.deletePGView pgViewName)
        redirectTo TablesAction


-- ensure all tables referenced in CREATE VIEW are in the schema.
validatePGView :: [Statement] -> Maybe Text -> Validator Text
validatePGView statements = validateNameInSchema "table name" (getAllObjectNames statements)
