collision = (sprite1, sprite2) ->
  collide = (sprite1.right() > sprite2.left() and
             sprite1.left() < sprite2.right() and
             sprite1.bottom() > sprite2.top() and
             sprite1.top() < sprite2.bottom())

  if not collide
    return false

  if sprite1.left() < sprite2.left()
    if sprite1.top() < sprite2.top()
      angle = Math.atan2(-sprite1.speedY, sprite1.speedX)
      if angle > -(Math.PI/4)
        return SIDE.left
      else
        return SIDE.top
    else if sprite1.bottom() > sprite2.bottom()
      angle = Math.atan2(-sprite1.speedY, sprite1.speedX)
      if  angle < (Math.PI/4)
        return SIDE.left
      else
        return SIDE.bottom
    else
      return SIDE.left

  if sprite1.right() > sprite2.right()
    if sprite1.top() < sprite2.top()
      angle = Math.atan2(-sprite1.speedY, sprite1.speedX)
      if angle < -3*(Math.PI/4) or angle > (Math.PI/2)
        return SIDE.right
      else
        return SIDE.top

    else if sprite1.bottom() > sprite2.bottom()
      angle = Math.atan2(-sprite1.speedY, sprite1.speedX)
      if angle > 3*(Math.PI/4) or angle < -Math.PI/2
        return SIDE.right
      else
        return SIDE.bottom
    else
      return SIDE.right

  if sprite1.bottom() > sprite2.bottom()
    return SIDE.bottom
  if sprite1.top() < sprite2.top()
    return SIDE.top
  console.log('unknown side')