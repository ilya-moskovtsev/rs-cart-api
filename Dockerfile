FROM node:12.16.3
WORKDIR app
COPY * ./
RUN npm install
RUN npm run build
USER node
EXPOSE 4000
ENTRYPOINT ["node", "dist/main.js"]