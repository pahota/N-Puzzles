import QtQuick 2.15

Rectangle {
    id: backgroundRect
    anchors.fill: parent
    gradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop {
            position: 0.0
            color: {
                if (themeIndex === 0) return "#F5F0E6"
                if (themeIndex === 1) return "#1A1D21"
                return "#161040"
            }
        }
        GradientStop {
            position: 1.0
            color: {
                if (themeIndex === 0) return "#E8D0AA"
                if (themeIndex === 1) return "#0F1112"
                return "#0A0720"
            }
        }
    }

    Item {
        id: particleContainer
        anchors.fill: parent
        property var particles: []

        Canvas {
            id: canvas
            anchors.fill: parent
            renderTarget: Canvas.FramebufferObject
            renderStrategy: Canvas.Cooperative

            function drawStar(ctx, size, color, x, y, rotation) {
                ctx.save()
                ctx.translate(x, y)
                ctx.rotate(rotation)

                var spikes = 5
                var outerRadius = size * 3.0
                var innerRadius = size * 1.2

                ctx.beginPath()
                ctx.fillStyle = color

                for (var j = 0; j < spikes * 2; j++) {
                    var radius = j % 2 === 0 ? outerRadius : innerRadius
                    var angle = Math.PI * j / spikes - Math.PI / 2
                    var sx = Math.cos(angle) * radius
                    var sy = Math.sin(angle) * radius

                    if (j === 0) {
                        ctx.moveTo(sx, sy)
                    } else {
                        ctx.lineTo(sx, sy)
                    }
                }

                ctx.closePath()
                ctx.fill()
                ctx.restore()
            }

            function drawMoon(ctx, size, color, x, y, rotation) {
                ctx.save()
                ctx.translate(x, y)
                ctx.rotate(rotation)

                var radius = size * 3.0

                ctx.beginPath()
                ctx.fillStyle = color
                ctx.arc(0, 0, radius, 0, Math.PI * 2, false)
                ctx.fill()

                ctx.beginPath()
                ctx.fillStyle = themeIndex === 0 ? "#F5F0E6" :
                               themeIndex === 1 ? "#1A1D21" : "#161040"
                ctx.arc(radius * 0.4, 0, radius * 0.9, 0, Math.PI * 2, false)
                ctx.fill()

                ctx.restore()
            }

            function drawSun(ctx, size, color, x, y, rotation) {
                ctx.save()
                ctx.translate(x, y)
                ctx.rotate(rotation)

                var radius = size * 3.0
                var rays = 8

                ctx.beginPath()
                ctx.fillStyle = color
                ctx.arc(0, 0, radius, 0, Math.PI * 2, false)
                ctx.fill()

                ctx.strokeStyle = color
                ctx.lineWidth = size * 0.5

                for (var j = 0; j < rays; j++) {
                    var angle = (Math.PI * 2 / rays) * j
                    var x1 = Math.cos(angle) * radius * 1.2
                    var y1 = Math.sin(angle) * radius * 1.2
                    var x2 = Math.cos(angle) * radius * 1.8
                    var y2 = Math.sin(angle) * radius * 1.8

                    ctx.beginPath()
                    ctx.moveTo(x1, y1)
                    ctx.lineTo(x2, y2)
                    ctx.stroke()
                }

                ctx.restore()
            }

            function drawTriangle(ctx, size, color, x, y, rotation) {
                ctx.save()
                ctx.translate(x, y)
                ctx.rotate(rotation)

                var radius = size * 3.0

                ctx.beginPath()
                ctx.fillStyle = color
                ctx.moveTo(0, -radius)
                ctx.lineTo(-radius * 0.866, radius * 0.5)
                ctx.lineTo(radius * 0.866, radius * 0.5)
                ctx.closePath()
                ctx.fill()

                ctx.restore()
            }

            function drawPuzzleTile(ctx, size, color, x, y, rotation, number) {
                ctx.save()
                ctx.translate(x, y)
                ctx.rotate(rotation)

                var tileSize = size * 4.0

                ctx.beginPath()
                ctx.fillStyle = color
                ctx.roundRect(-tileSize/2, -tileSize/2, tileSize, tileSize, tileSize * 0.1)
                ctx.fill()

                ctx.fillStyle = themeIndex === 0 ? "#000000" : "#FFFFFF"
                ctx.font = Math.floor(tileSize * 0.6) + "px Arial"
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                ctx.fillText(number, 0, 0)

                ctx.restore()
            }

            function drawCircle(ctx, size, color, x, y) {
                ctx.save()
                ctx.translate(x, y)

                ctx.beginPath()
                ctx.fillStyle = color
                ctx.arc(0, 0, size * 2.5, 0, Math.PI * 2, false)
                ctx.fill()

                ctx.restore()
            }

            function drawDiamond(ctx, size, color, x, y, rotation) {
                ctx.save()
                ctx.translate(x, y)
                ctx.rotate(rotation)

                var side = size * 3.0

                ctx.beginPath()
                ctx.fillStyle = color
                ctx.moveTo(0, -side)
                ctx.lineTo(side, 0)
                ctx.lineTo(0, side)
                ctx.lineTo(-side, 0)
                ctx.closePath()
                ctx.fill()

                ctx.restore()
            }

            function drawSpiral(ctx, size, color, x, y, rotation) {
                ctx.save()
                ctx.translate(x, y)
                ctx.rotate(rotation)

                ctx.strokeStyle = color
                ctx.lineWidth = size * 0.7

                var radius = size * 2.0
                var turns = 3
                var points = 60

                ctx.beginPath()
                for (var i = 0; i <= points; i++) {
                    var angle = (i / points) * Math.PI * 2 * turns
                    var r = (i / points) * radius * 3
                    var px = Math.cos(angle) * r
                    var py = Math.sin(angle) * r

                    if (i === 0) {
                        ctx.moveTo(px, py)
                    } else {
                        ctx.lineTo(px, py)
                    }
                }
                ctx.stroke()

                ctx.restore()
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                var gradColor = themeIndex === 0 ? "#A67C52" :
                                themeIndex === 1 ? "#6D6D8D" : "#9370DB"

                if (width > 800) {
                    ctx.strokeStyle = gradColor
                    ctx.globalAlpha = 0.05
                    ctx.lineWidth = 0.8

                    var gridSize = 150
                    var waveAmplitude = 5
                    var waveFrequency = 0.08

                    for (var i = 0; i < width; i += gridSize) {
                        for (var j = 0; j < height; j += gridSize) {
                            ctx.beginPath()

                            var x1 = i
                            var y1 = j
                            var x2 = i + gridSize
                            var y2 = j
                            var x3 = i + gridSize
                            var y3 = j + gridSize
                            var x4 = i
                            var y4 = j + gridSize

                            ctx.moveTo(
                                x1,
                                y1 + Math.sin(x1 * waveFrequency) * waveAmplitude
                            )

                            for (var step = 1; step <= 20; step++) {
                                var t = step / 20
                                var x = x1 + (x2 - x1) * t
                                var y = y1 + (y2 - y1) * t
                                y += Math.sin(x * waveFrequency) * waveAmplitude
                                ctx.lineTo(x, y)
                            }

                            for (step = 1; step <= 20; step++) {
                                var t = step / 20
                                var x = x2 + (x3 - x2) * t
                                var y = y2 + (y3 - y2) * t + Math.sin(x * waveFrequency) * waveAmplitude
                                ctx.lineTo(x, y)
                            }

                            for (step = 1; step <= 20; step++) {
                                var t = step / 20
                                var x = x3 + (x4 - x3) * t
                                var y = y3 + (y4 - y3) * t + Math.sin(x * waveFrequency) * waveAmplitude
                                ctx.lineTo(x, y)
                            }

                            for (step = 1; step <= 20; step++) {
                                var t = step / 20
                                var x = x4 + (x1 - x4) * t
                                var y = y4 + (y1 - y4) * t + Math.sin(x * waveFrequency) * waveAmplitude
                                ctx.lineTo(x, y)
                            }

                            ctx.closePath()
                            ctx.stroke()
                        }
                    }
                }

                for (var k = 0; k < particleContainer.particles.length; k++) {
                    var p = particleContainer.particles[k]
                    var size = p.size * 1.8
                    ctx.globalAlpha = p.opacity

                    if (p.type === 0) {
                        drawStar(ctx, size, p.color, p.x, p.y, p.rotation)
                    } else if (p.type === 1) {
                        drawMoon(ctx, size, p.color, p.x, p.y, p.rotation)
                    } else if (p.type === 2) {
                        drawSun(ctx, size, p.color, p.x, p.y, p.rotation)
                    } else if (p.type === 3) {
                        drawTriangle(ctx, size, p.color, p.x, p.y, p.rotation)
                    } else if (p.type === 4) {
                        drawPuzzleTile(ctx, size, p.color, p.x, p.y, p.rotation, p.number)
                    } else if (p.type === 5) {
                        drawCircle(ctx, size, p.color, p.x, p.y)
                    } else if (p.type === 6) {
                        drawDiamond(ctx, size, p.color, p.x, p.y, p.rotation)
                    } else if (p.type === 7) {
                        drawSpiral(ctx, size, p.color, p.x, p.y, p.rotation)
                    }
                }
            }
        }

        Component.onCompleted: initializeTheme()

        function initializeTheme() {
            var lightThemeObjects = [
                {type: 2, x: width * 0.12, y: height * 0.15, size: 4.0, opacity: 0.8, color: "#FFD700", rotation: 0.2},
                {type: 2, x: width * 0.88, y: height * 0.18, size: 3.3, opacity: 0.7, color: "#FFA500", rotation: 0.4},
                {type: 4, x: width * 0.25, y: height * 0.32, size: 2.3, opacity: 0.7, color: "#D2B48C", rotation: 0.1, number: 1},
                {type: 4, x: width * 0.38, y: height * 0.45, size: 2.2, opacity: 0.7, color: "#CD853F", rotation: -0.1, number: 2},
                {type: 4, x: width * 0.58, y: height * 0.38, size: 2.1, opacity: 0.7, color: "#DEB887", rotation: 0.05, number: 3},
                {type: 4, x: width * 0.75, y: height * 0.25, size: 2.4, opacity: 0.7, color: "#B8860B", rotation: -0.05, number: 4},
                {type: 5, x: width * 0.18, y: height * 0.7, size: 1.9, opacity: 0.6, color: "#8B4513", rotation: 0},
                {type: 5, x: width * 0.82, y: height * 0.65, size: 1.7, opacity: 0.6, color: "#A0522D", rotation: 0},
                {type: 6, x: width * 0.32, y: height * 0.8, size: 2.2, opacity: 0.6, color: "#CD853F", rotation: 0.4},
                {type: 6, x: width * 0.68, y: height * 0.85, size: 2.0, opacity: 0.6, color: "#D2691E", rotation: 1.2},
                {type: 3, x: width * 0.45, y: height * 0.58, size: 2.5, opacity: 0.5, color: "#FF8C00", rotation: 1.1},
                {type: 7, x: width * 0.55, y: height * 0.75, size: 2.3, opacity: 0.6, color: "#B8860B", rotation: 1.7}
            ];

            var darkThemeObjects = [
                {type: 0, x: width * 0.08, y: height * 0.12, size: 2.3, opacity: 0.8, color: "#E6E6FA", rotation: 0.7},
                {type: 0, x: width * 0.25, y: height * 0.08, size: 2.0, opacity: 0.7, color: "#F0F8FF", rotation: 0.3},
                {type: 0, x: width * 0.42, y: height * 0.15, size: 1.7, opacity: 0.6, color: "#F5F5F5", rotation: 1.1},
                {type: 0, x: width * 0.92, y: height * 0.08, size: 2.1, opacity: 0.7, color: "#F8F8FF", rotation: 0.9},
                {type: 0, x: width * 0.75, y: height * 0.12, size: 1.9, opacity: 0.6, color: "#FFFFFF", rotation: 1.5},
                {type: 1, x: width * 0.85, y: height * 0.25, size: 3.7, opacity: 0.8, color: "#F5F5F5", rotation: 2.1},
                {type: 6, x: width * 0.15, y: height * 0.35, size: 2.2, opacity: 0.6, color: "#D3D3D3", rotation: 0.4},
                {type: 6, x: width * 0.65, y: height * 0.42, size: 2.0, opacity: 0.5, color: "#DCDCDC", rotation: 1.2},
                {type: 5, x: width * 0.32, y: height * 0.6, size: 1.9, opacity: 0.5, color: "#C0C0C0", rotation: 0},
                {type: 5, x: width * 0.78, y: height * 0.55, size: 1.7, opacity: 0.6, color: "#A9A9A9", rotation: 0},
                {type: 3, x: width * 0.25, y: height * 0.78, size: 2.7, opacity: 0.5, color: "#BEBEBE", rotation: 0.7},
                {type: 3, x: width * 0.68, y: height * 0.85, size: 2.3, opacity: 0.6, color: "#D8BFD8", rotation: 1.1},
                {type: 7, x: width * 0.5, y: height * 0.7, size: 2.5, opacity: 0.6, color: "#B0C4DE", rotation: 0.5}
            ];

            var colorThemeObjects = [
                {type: 0, x: width * 0.05, y: height * 0.08, size: 2.0, opacity: 0.7, color: "#E6E6FA", rotation: 0.3},
                {type: 0, x: width * 0.15, y: height * 0.05, size: 1.8, opacity: 0.8, color: "#D8BFD8", rotation: 0.7},
                {type: 0, x: width * 0.25, y: height * 0.1, size: 1.7, opacity: 0.6, color: "#DDA0DD", rotation: 1.1},
                {type: 0, x: width * 0.88, y: height * 0.06, size: 1.9, opacity: 0.7, color: "#DA70D6", rotation: 0.9},
                {type: 0, x: width * 0.75, y: height * 0.08, size: 1.6, opacity: 0.8, color: "#BA55D3", rotation: 1.5},
                {type: 1, x: width * 0.65, y: height * 0.22, size: 4.0, opacity: 0.8, color: "#F5F5F5", rotation: 2.1},
                {type: 6, x: width * 0.18, y: height * 0.38, size: 2.2, opacity: 0.7, color: "#9370DB", rotation: 0.4},
                {type: 6, x: width * 0.81, y: height * 0.45, size: 2.0, opacity: 0.6, color: "#8A2BE2", rotation: 1.2},
                {type: 7, x: width * 0.34, y: height * 0.62, size: 2.5, opacity: 0.7, color: "#9932CC", rotation: 0.5},
                {type: 7, x: width * 0.72, y: height * 0.58, size: 2.3, opacity: 0.7, color: "#800080", rotation: 1.7},
                {type: 5, x: width * 0.23, y: height * 0.78, size: 1.9, opacity: 0.6, color: "#9400D3", rotation: 0},
                {type: 5, x: width * 0.45, y: height * 0.85, size: 1.7, opacity: 0.7, color: "#8B008B", rotation: 0},
                {type: 3, x: width * 0.62, y: height * 0.75, size: 2.7, opacity: 0.6, color: "#9370DB", rotation: 0.7},
                {type: 3, x: width * 0.88, y: height * 0.82, size: 2.3, opacity: 0.7, color: "#7B68EE", rotation: 1.1}
            ];

            particleContainer.particles = themeIndex === 0 ? lightThemeObjects :
                                        themeIndex === 1 ? darkThemeObjects :
                                        colorThemeObjects;
            canvas.requestPaint();
        }
    }

    Rectangle {
        id: glowOverlay
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop {
                position: 0.0
                color: "transparent"
            }
            GradientStop {
                position: 0.85
                color: {
                    if (themeIndex === 0) return "#20F8F0E3"
                    if (themeIndex === 1) return "#201A1D21"
                    return "#201A1060"
                }
            }
            GradientStop {
                position: 1.0
                color: {
                    if (themeIndex === 0) return "#40E8D0AA"
                    if (themeIndex === 1) return "#400F1112"
                    return "#400A0720"
                }
            }
        }
    }

    ShaderEffect {
        id: shaderGlow
        anchors.fill: parent
        property real time: 0
        property var sourceItem: glowOverlay
        property color accentColor: {
            if (themeIndex === 0) return "#CD853F"
            if (themeIndex === 1) return "#606080"
            return "#9370DB"
        }

        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform lowp float qt_Opacity;
            uniform lowp float time;
            uniform lowp vec4 accentColor;

            void main() {
                highp vec2 p = qt_TexCoord0 * 2.0 - 1.0;
                highp float glow = 0.03 / (0.1 + abs(p.y + 0.6 + sin(p.x * 3.0) * 0.1));
                highp vec4 glowColor = vec4(accentColor.rgb, glow * 0.2);
                gl_FragColor = glowColor * qt_Opacity;
            }
        "
    }

    Connections {
        target: parent
        function onThemeIndexChanged() {
            particleContainer.initializeTheme();
        }
    }
}
