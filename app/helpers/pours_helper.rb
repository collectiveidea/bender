module PoursHelper
  def last_pour(user)
    pour_at = user.last_pour_at
    if pour_at
      "Last activity: #{I18n.l(pour_at, format: :norm)}"
    else
      "No activity yet"
    end
  end
end
