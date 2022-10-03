module IHP.IDE.SchemaDesigner.Controller.PGViews where

import IHP.ControllerPrelude
import IHP.IDE.ToolServer.Types

import IHP.IDE.SchemaDesigner.View.PGViews.New
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


instance Controller PGViewsController where
    beforeAction = setLayout schemaDesignerLayout

    action NewPGViewAction = do
        statements <- readSchema
        render NewPGViewView { .. }
