// Used in the new session form to set the "player_color" hidden
// input field value to the selected color. Also updates the
// background color of the "player_name" input field, just for fun!

// Used in the new session form to set the "player_color" hidden
// input field value to the selected color. Also updates the
// background color of the "player_name" input field, just for style points.

const colors = document.querySelectorAll("#color-selector .color")

colors.forEach(color => {
  color.addEventListener('click', function () {
    const currentlySelected =
      document.querySelector("#color-selector .color.selected")

    currentlySelected.classList.remove('selected')

    this.classList.add('selected')

    const selectedColor = this.style.backgroundColor

    const playerColor =
      document.querySelector("#player_color")

    playerColor.value = selectedColor

    const playerName =
      document.querySelector("#player_name")

    playerName.style.borderColor = selectedColor
  })
})
