<!-- views/chatgpt.vue -->
<template>
    <div class="common-layout">
        <el-container>
            <el-header :style="{ backgroundColor: isDark ? 'dark' : '' }" style="height: 20px;">
                <el-row>
                    <el-col :span="6">
                        <div>


                        </div>
                    </el-col>
                    <el-col :span="12">
                        <span :style="{ color: isDark ? '#CFD3DC' : '' }">超大模型AI对话</span>
                    </el-col>
                    <el-col :span="6">
                        <div>
                            <el-switch v-model="isDark"
                                style="--el-switch-on-color: #585454; --el-switch-off-color: #E7E7E7;" :active-icon="Moon"
                                :inactive-icon="Sunny" inline-prompt />
                            {{ isDark }}
                        </div>
                    </el-col>
                </el-row>
            </el-header>
            <el-divider />
            <el-container>
                <el-aside style="background-color:{{ isDark }};text-align: center;width: 15%;">
                </el-aside>

                <el-container>
                    <el-main style="height:380px ;width:100%;" :style="{ backgroundColor: isDark ? '#39393A' : '#E6E8EB' }">
                        <el-descriptions column=1 size="small" border="true" style="width:100%;">
                        
                            <div v-for="item in chatRecord" :key="item" style="background-color;:{{ isDark }}">
                                <el-descriptions-item :label="item.sender" label-align="center">
                                    <span v-html=item.message></span>
                                </el-descriptions-item>
                            </div>
                        </el-descriptions>
           
                        <div class="centered-text">OpenAI <br/>基于 OpenAI 的 ChatGPT 自然语言模型人工智能对话</div>
                    </el-main>
                    <el-footer style="padding:10px;height:5%;">
                        <el-row>
                            <el-col :span="20">
                                <div style="width:100%; height: 100px;">
                                    <el-input v-model="question" type="textarea" placeholder="请输入你的问题"
                                        :autosize="{ minRows: 5, maxRows: 7 }" resize="none" show-word-limit
                                        maxlength="300" />
                                </div>
                            </el-col>
                            <el-col :span="4">
                                <div style="text-align: right; margin-top:20%">
                                    <el-button type="primary" @click="chat" :disabled="click">发送</el-button>
                                </div>
                            </el-col>
                        </el-row>

                    </el-footer>
                </el-container>
                <el-aside style="background-color:{{ isDark }};text-align: center;width: 15%;">
                </el-aside>
            </el-container>
        </el-container>

    </div>
</template>

<script >
import { useDark, useToggle, useColorMode } from '@vueuse/core';
import { Sunny, Moon } from '@element-plus/icons-vue'

export default {
    name: 'ChatGPT',
    setup() {
        const isDark = useDark();
        const toggleDark = useToggle(isDark);
        const colorMode = useColorMode();
        return { isDark, colorMode, Sunny, Moon, toggleDark };
    },
    data() {
        return {
            question: "",
            count: 0,
            click: false,
            chatRecord: [{ sender: "AI:", message: "您好，有什么需要向我提问的吗？" }]
        }
    },
    methods: {

        chat() {
            this.click = true;
            //  var apiKey='sk-7VNN3HiU3sJB9EH2YL8T3BlbkFJUCy1OAz6s3rgSTDqgRc2';
            //  var sessionId ='8d2cb1b1-d535-43a8-b738-4f61b1608579';
            let url = 'http://152.32.207.34:8087/request?question=' + this.question;
        //    let url = 'https://api.openai-proxy.com/pro/chat/completions?content=' + this.question +'='+apiKey+'='+sessionId;
            var you = { sender: "YOU:", message: this.question };
            var ai = { sender: "AI:", message: "" };
            this.chatRecord.push(you);
            this.chatRecord.push(ai);
            this.question = "";
            console.log(this.question);
            let es = new EventSource(url);
            es.addEventListener('message', event => {

                console.log(event.data);

                this.count++;
                if (this.count > 2) {
                    if (event.data.toString() === "Answer Done!") {
                        es.close();
                        this.count = 0;
                        this.click = false;
                    } else {
                        var ai = this.chatRecord[this.chatRecord.length - 1]
                        ai.message += event.data;
                        this.chatRecord[this.chatRecord.length - 1] = ai;
                    }
                }
            });
        }
    }
}
</script>
<style>
/* 背景颜色 */
.dark {
    background: #252525;
    color: white;
}

.light {
    background: white;
    color: black;
}
.centered-text {
  text-align: center;
  margin-top:15%;
}
</style>

