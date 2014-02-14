module PoursHelper
  def last_pour(user)
    if pour_at = user.last_pour_at
      "Last activity: #{pour_at.strftime("%a, %b %d %Y %l:%M %p")}"
    else
      "No activity yet"
    end
  end
end
