//Declare a 2D texture as a uniform variable
uniform sampler2D videoFrame;
uniform float exposure;

void main()
{
      
  gl_FragColor = texture2D(videoFrame, gl_TexCoord[0].xy) * exposure;
}
