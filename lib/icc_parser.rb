class ICCParser # Copyright and description are parsed, at least. And content is divided to tags...
  def self.parse icc_profile
    icc_profile = icc_profile.b
    ret = {}
    ret[:creator] = icc_profile[80..83]
    pos = 127 # End of header
    tagnum = icc_profile[128..131].unpack("C*").inject { |r, n| r << 8 | n }
    pos = 132
    ret[:tags] = {}
    for i in 1..tagnum
      name = icc_profile[pos..pos+3]
      offset = icc_profile[pos+4..pos+7].unpack("C*").inject { |r, n| r << 8 | n }
      size = icc_profile[pos+8..pos+11].unpack("C*").inject { |r, n| r << 8 | n }
      if name == "cprt"
        value = icc_profile[offset+8..offset+size-2]
      elsif name == "desc"
        textsize = icc_profile[offset+10..offset+11].unpack("C*").inject { |r, n| r << 8 | n }
        value = icc_profile[offset+12..offset+10+textsize]
      else
        value = icc_profile[offset..offset+size]
      end
      ret[:tags][name.to_sym] = value
      pos += 12
    end
    return ret
  end
end
