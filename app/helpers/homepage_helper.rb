module HomepageHelper
  def homepage_tap_header(tap)
    header = tap.name.html_safe
    header += ": "
    keg = tap.active_keg
    header + if keg
      link_to keg.name, keg
    else
      "Offline"
    end
  end
end
