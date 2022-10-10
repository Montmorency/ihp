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
        let queryText = "create your view query."
        render NewPGViewView { .. }

    action CreatePGViewAction = do
        statements <- readSchema
        let pgViewName::Text = param "pgViewName"
        let viewQuery::Text = param "query"
        --let validationResults = tableNames |> map (validateTable statements Nothing)
        -- case validationResult of ...
        updateSchema (SchemaOperations.addPGView pgViewName)
        redirectTo TablesAction

-- ensure all tables referenced in CREATE VIEW are in the schema.
validatePGView :: [Statement] -> Maybe Text -> Validator Text
validatePGView statements = validateNameInSchema "table name" (getAllObjectNames statements)
