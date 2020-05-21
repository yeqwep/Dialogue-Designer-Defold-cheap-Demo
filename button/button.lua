local M = {}

M.action_id_touch       = hash("touch")
M.action_id_multi       = hash("multi")

function M.create(node, callback)
	local button = {pressed = false, hover = false}

	gui.set_color(node,vmath.vector4(0.6,0.6,0.6,0.9))

	function button.on_input(action_id, action)
		local over = gui.pick_node(node, action.x, action.y)

		if over then
			button.hover = true
			gui.animate(node, 'color', vmath.vector4(1,1,1,1), go.EASING_OUTQUAD, 0.2)
		elseif over == false and button.hover then
			button.hover = false
			gui.animate(node, 'color', vmath.vector4(0.6,0.6,0.6,0.9), go.EASING_OUTQUAD, 0.2)
		end

		if button.hover and action.pressed and action_id == M.action_id_touch then
			button.pressed = true
			gui.animate(node, 'scale', vmath.vector3(1.01, 0.97, 1), go.EASING_OUTQUAD, 0.1)
			gui.animate(node, 'color', vmath.vector4(0.6,0.6,0.6,0.9), go.EASING_OUTQUAD, 0.2)
		elseif action.released and button.pressed and action_id == M.action_id_touch then
			button.pressed = false
			gui.cancel_animation(node,'scale')
			gui.cancel_animation(node,'color')
			gui.set_scale(node,vmath.vector3(1,1,1))
			gui.set_color(node,vmath.vector4(0.6,0.6,0.6,0.9))
			if button.hover then
				callback(button)
			end
		end
	end

	return button
end

function M.toggle_create(node, flag, callback)
	local button = {pressed = false, hover = false}
	local anim = {on = hash("b_on"), off = hash("b_off")}

	gui.play_flipbook(node, flag and anim.on or anim.off)

	local col = {on = vmath.vector4(0.0,0.0,1.0,1), off = vmath.vector4(1,1,1,1)}
	gui.set_color(node,flag and col.on or col.off)

	function button.on_input_t(action_id, action, flag)
		local over = gui.pick_node(node, action.x, action.y)

		if over and action.pressed and action_id == M.action_id_touch then
			button.pressed = true
		elseif action.released and button.pressed and action_id == M.action_id_touch then
			button.pressed = false
			if over then
				flag = not flag
				gui.play_flipbook(node, flag and anim.on or anim.off)
				gui.set_color(node,flag and col.on or col.off)
				callback(button)
			end
		end
	end

	function button.toggle(flag)
		flag = not flag
		gui.play_flipbook(node, flag and anim.on or anim.off)
		gui.set_color(node,flag and col.on or col.off)
		callback(button)
	end

	return button
end

return M