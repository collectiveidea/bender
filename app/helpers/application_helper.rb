module ApplicationHelper
  include Pagy::Frontend

  def errors_for(model, separator = "<br>".html_safe)
    messages = "".html_safe
    model.errors.full_messages.each do |msg|
      messages << msg
      messages << separator
    end
    messages
  end

  def kegerator_name
    ENV.fetch("KEGERATOR_NAME", "[i] Kegerator")
  end
end
