# CsvImporter

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csv_importer'
```

And then execute:

    $ bundle

## Usage

```ruby
?> rails g csv_importer:install
?> rake db:migrate
?> rake csv_importer:all
```

## How it Works

By default, `csv_importer` looks for CSV files in `public/csv_import/TABLE_NAME/*.csv`. `TABLE_NAME` stands for the name of table (e.g: `users`, ...). Each file may require a header that contains the exact name of the field. If it's not the case, a [hook]() is provided to re-organize the mapping of the file before check. 

Before the update of a field, `csv_importer` will check if csv column value has never been a value of the table field (e.g: Update the email only if has never been an email of the person).

However, it's possible to custom the list of field to look up via a `whitelisting` [config](). 

# Tools

The gem provides 2 tools: a rake tasks and a rails generator.

The rails generator `csv_importer:install` provides 2 files:

```shell
$ rails g csv_importer:install
  create  config/initializers/csv_importer.rb
  create  db/migrate/20160831080017_create_csv_importer_histories.rb
```

The `csv_importer.rb` initializer permits to manage the path of the CSV files and the whitelisting for the history.

```ruby
CSVImporter.configure({
  file_loader: { loader: :file_system, path: "#{Rails.root}public/" },
  history_whitelisting: {
    buildings: [:manager_name],
    people:    [:email, :phone_number, :cell_phone, :address]
  }
})
```

The rake task `csv_importer:all` iterates through each file available in the `path` defined in config.

## Extend functionality

#### Internals


###Contact

Thanks for reading.

[Twitter](https://twitter.com/farsi_mehdi)<br/>
[GitHub](https://github.com/mehdi-farsi/)<br/>
[LinkedIn](https://fr.linkedin.com/in/mehdifarsi)<br/>

