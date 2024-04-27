util.AddNetworkString("SublimeGov.Notify");

function SublimeGov.GlobalNotify(text)
    if (not text or text == "") then
        return;
    end
    print("ansdukjasnkl")
    net.Start("SublimeGov.Notify");
        net.WriteString(text);
    net.Broadcast()
end 