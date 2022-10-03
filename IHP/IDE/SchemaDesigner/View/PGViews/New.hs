module IHP.IDE.SchemaDesigner.View.PGViews.New where

import IHP.ViewPrelude
import IHP.IDE.SchemaDesigner.Types
import IHP.IDE.ToolServer.Types
import IHP.IDE.ToolServer.Layout
import IHP.IDE.SchemaDesigner.View.Layout

data NewPGViewView = NewPGViewView { statements :: [Statement]
                                   , queryText :: Text
                                   }

instance View NewPGViewView where
    html NewPGViewView { .. } = [hsx|
        <div class="row no-gutters bg-white" id="schema-designer-viewer">
            {renderObjectSelector (zip [0..] statements) Nothing}
            {emptyColumnSelectorContainer}
        </div>
        {migrationStatus}
        {renderModal modal}
    |]
        where
            modalContent = [hsx|
                <form method="POST" action={CreatePGViewAction}>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">Name:</label>
                        <div class="col-sm-10">
                            <input id="nameInput" name="tableName" type="text" class="form-control" autofocus="autofocus"/>
                            <small class="text-muted">
                                Use the plural form and underscores. E.g.: <code>projects_view</code>, <code>companies_view</code>, <code>user_reactions_view</code>
                                and append _view.
                            </small>
                        </div>
                     </div>

                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">Query:</label>
                        <div class="col-sm-10">
                            <input id="nameInput" name="tableName" type="text" class="form-control" autofocus="autofocus"/>
                            <input type="hidden" name="query" value={queryText}/>
                            <div class="p-2 rounded my-2" style="background-color: #002B36; border: 1px solid #0B5163;">
                              <div class="query-editor" style="height:16px">{queryText}</div>
                            </div>

                            <small class="text-muted">
                               Write the query <code> select * from films where genre='comedies'; </code> and the schema designer will generate the
                               view statement.
                            </small>
                        </div>
                     </div>


                    <div class="text-right">
                        <button type="submit" class="btn btn-primary">Create Postgres View</button>
                    </div>
                </form>
            |]
            modalFooter = mempty
            modalCloseUrl = pathTo TablesAction
            modalTitle = "New Postgres View"
            modal = Modal { modalContent, modalFooter, modalCloseUrl, modalTitle }
