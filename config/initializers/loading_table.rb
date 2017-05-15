$model_classes = (ActiveRecord::Base.connection.tables - %w[schema_migrations activities ckeditor_assets ar_internal_metadata])
                   .map{|model| model.classify.constantize}
