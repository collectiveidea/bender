# Pin npm packages by running ./bin/importmap

pin "application"
pin "@rails/ujs", to: "https://cdn.skypack.dev/rails-ujs" # https://github.com/rails/rails/issues/43242
pin "d3.v2"
pin "jquery.min"
pin "jquery.dataTables"
pin "rickshaw"
pin_all_from "app/javascript"
