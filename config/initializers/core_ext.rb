class Hash
	def symbolize!
		replace(Hash[self.map{|(k,v)| [k.to_sym,v]}])
	end
end