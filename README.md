# Unity-GLSL-starter


Example unity project with a working Vertex (for algorithmic vertex displacement) and Fragment (for using the 3d model's original texture)

This project implements a GLSL shader that does vertext displacement (vertex shader) by bending and twisting the vertices of the model. 

To try it, open the scene called "GLSL Party", select the game object called "cop" and play around with the sliders under the "testShaderMaterial" component.

Notes:
- To make a shader, you need to create a new "Shader" and a new "Material", whose selectedh Shader is the shader you have written
- To maitain the custom texture of your model, you create a new texture, assign the right jpg to it, and then drag that onto the "Texture Image" property of the "testShaderMaterial" component 


References:
- https://en.wikibooks.org/wiki/GLSL_Programming/Unity/Textured_Spheres
- https://docs.unity3d.com/Manual/SL-GLSLShaderPrograms.html
- 
