# Pro-Vehicle-Camera
A professional-grade, smooth, and feature-rich  vehicle camera plugin for Godot 4, featuring dynamic FOV, corner banking, and built-in juice effects.
# Pro Vehicle Camera for Godot 4

**Pro Vehicle Camera** is a production-ready camera controller designed for  games. It eliminates the "robotic" feel of standard cameras by using an elastic tether system, offering fluid motion that reacts to the physics of your vehicle.

## 🚀 Key Features

* **Elastic Tracking:** Smooth, weight-based following with no jarring deadzones.
* **Auto-Align Look-Back:** A professional look-back system that automatically swings the camera to the rear and recovers smoothly when released.
* **Dynamic FOV:** Speed-dependent Field of View stretching to increase the sensation of velocity.
* **Corner Banking:** Subtle, realistic camera tilt during steering maneuvers.
* **Juice System:** A simple `trigger_shake(intensity, duration)` function for impacts and collisions.
* **Inspector Control:** Easily enable or disable features directly from the Godot Inspector.

## 📦 Installation

1.  **Download:** Download this repository as a ZIP file.
2.  **Move Folder:** Extract the ZIP and copy the `addons/pro_vehicle_camera/` folder into your project's `res://addons/` directory.
3.  **Enable:** Open Godot, go to **Project > Project Settings > Plugins**, and set **Pro Vehicle Camera** to **Enabled**.
4.  **Use:** Add the `ProVehicleCamera` node to your scene and drag your vehicle node into the **Follow This** slot in the Inspector.

## ⚙️ Usage Tips

* **Input Map:** Ensure you have an action defined in **Project > Input Map** that matches the `Look Back Action` setting (default is `"look_back"`).
* **Vehicle Setup:** The plugin automatically detects `linear_velocity` (for `VehicleBody3D`) and `steering` (if defined in your vehicle script).
* **Juice:** To trigger a shake during a crash, call the following from your vehicle's collision script:
    ```gdscript
    $ProVehicleCamera.trigger_shake(0.5, 0.2)
    ```

## 📜 License
MIT License. Feel free to use this in any commercial or personal project.

If you found this framework helpful for your Godot project, please consider starring the repo—it helps others find it too!
