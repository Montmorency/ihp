module IHP.IDE.SchemaDesigner.Controller.Views where

import IHP.ControllerPrelude
import IHP.IDE.ToolServer.Types

import IHP.IDE.SchemaDesigner.View.Views.New
--import IHP.IDE.SchemaDesigner.View.Views.Show
--import IHP.IDE.SchemaDesigner.View.Views.Index
--import IHP.IDE.SchemaDesigner.View.Views.Edit

import IHP.IDE.SchemaDesigner.Types
import IHP.IDE.SchemaDesigner.View.Layout (findStatementByName, replace, schemaDesignerLayout)
import qualified IHP.SchemaCompiler as SchemaCompiler
import IHP.IDE.SchemaDesigner.Controller.Helper
import IHP.IDE.SchemaDesigner.Controller.Validation
import IHP.IDE.SchemaDesigner.Controller.Columns (updateForeignKeyConstraint)
import qualified IHP.IDE.SchemaDesigner.SchemaOperations as SchemaOperations


instance Controller ViewsController where
    beforeAction = setLayout schemaDesignerLayout

    action NewViewAction = do
        statements <- readSchema
        render NewViewView { .. }
