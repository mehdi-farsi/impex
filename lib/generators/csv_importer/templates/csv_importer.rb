# CSVImporter.configure({
#   file_loader: { loader: :file_system, path: "#{Rails.root}public/" },
#   history_manager: { manager: :active_record, table: "csv_importer_histories" },
#   history_whitelisting: {
#     buildings: [:manager_name],
#     people:    [:email, :phone_number, :cell_phone, :address]
#   }
# })