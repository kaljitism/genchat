const { OpenAI } = require('openai');
const net = require('net');


const openai = new OpenAI({
  apiKey: '<Your Nvidia NIMS API>',
  baseURL: 'https://integrate.api.nvidia.com/v1',
});

(async () => {
  const server = await net.createServer(
     socket => {
      socket.on('data', async data => {
        if (data.toString().trim().length > 0) {
          const content = data.toString();
          console.log('content: ', content);
          
          const completion = await openai.chat.completions.create(
            {
              model: "meta/llama3-70b-instruct",
              messages: [{"role": "user", "content": `${content}`}],
              temperature: 0.5,
              top_p: 1,
              max_tokens: 1024,
              stream: true,
            });
          
          let response = '';
          for await (const chunk of completion) {
            response += chunk.choices[0]?.delta?.content || '';
          }
          response.trim();
          console.log('response: ', response);
          socket.write(response);
        }
      });
    }
  );
  
  server.listen(8080, '0.0.0.0', () => {
    console.log('Server listening on port 8080');
  })
  
  server.on('connection', socket => {
    console.log(`Client connected: ${socket.remoteAddress}:${socket.remotePort}`);
  })
  
  server.on('error', error => console.log(error));
}) ();
