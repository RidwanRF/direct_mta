addCommandHandler('inv', function(player, cmd)
    if not getAdmin(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie posiadasz uprawnień do tej komendy!') end

    if getElementAlpha(player) == 255 then
        setElementAlpha(player, 0)
    else
        setElementAlpha(player, 255)
    end
    exports['borsuk-notyfikacje']:addNotification(player, 'success', 'Sukces', 'Zmieniono widzialność!')
end)