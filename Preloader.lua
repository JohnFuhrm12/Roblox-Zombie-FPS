spawn(function()
	game:GetService('ContentProvider'):PreloadAsync({workspace,game:GetService('ReplicatedStorage'),game:GetService('PlayerGui')})
end)