-- Users table to store user information
CREATE TABLE limpuser (
    id VARCHAR PRIMARY KEY,
    account VARCHAR UNIQUE NOT NULL,
    oauth_source VARCHAR NOT NULL,
    nickname VARCHAR NOT NULL,
    avatar VARCHAR NOT NULL,
    role SMALLINT NOT NULL,  -- role for simple permission system
    status SMALLINT NOT NULL,  -- current status of this account, like normal, frozen, deleted, ...
    created_at BIGINT NOT NULL
);
CREATE TABLE limpuser_idhash (
	id VARCHAR PRIMARY KEY,
	hash VARCHAR NOT NULL
);

-- Conversations table to represent one-on-one or group chats
CREATE TABLE limpconversation (
    id VARCHAR PRIMARY KEY,
    is_group BOOLEAN NOT NULL DEFAULT FALSE,
    group_name VARCHAR NOT NULL,
    created_at BIGINT NOT NULL
);
CREATE TABLE limpconversation_idhash (
	id VARCHAR PRIMARY KEY,
	hash VARCHAR NOT NULL
);

-- Conversation participants table to map users to conversations
CREATE TABLE limpconversationparticipant (
    id VARCHAR PRIMARY KEY,
    conversation_id VARCHAR REFERENCES limpconversation(id) ON DELETE RESTRICT,
    user_id VARCHAR REFERENCES limpuser(id) ON DELETE RESTRICT,
    joined_at BIGINT NOT NULL
);
CREATE TABLE limpconversationparticipant_idhash (
	id VARCHAR PRIMARY KEY,
	hash VARCHAR NOT NULL
);

-- Messages table to store individual messages
CREATE TABLE limpmessage (
    id VARCHAR PRIMARY KEY,
    conversation_id VARCHAR REFERENCES limpconversation(id) ON DELETE RESTRICT,
    sender_id VARCHAR REFERENCES limpuser(id) ON DELETE RESTRICT,
    content TEXT NOT NULL,
    sent_at BIGINT NOT NULL,
    expired_at BIGINT NOT NULL,
    attachment_url VARCHAR NOT NULL
);
CREATE TABLE limpmessage_idhash (
	id VARCHAR PRIMARY KEY,
	hash VARCHAR NOT NULL
);

-- Message status table to track message status per user
CREATE TABLE limpmessagestatus (
	id VARCHAR PRIMARY KEY,
    message_id VARCHAR REFERENCES limpmessage(id) ON DELETE RESTRICT,
    user_id VARCHAR REFERENCES limpuser(id) ON DELETE RESTRICT,
    status SMALLINT NOT NULL CHECK (status IN (0, 1, 2)),
    updated_at BIGINT NOT NULL,
    UNIQUE (message_id, user_id) -- Ensure one status per user per message
);
CREATE TABLE limpmessagestatus_idhash (
	id VARCHAR PRIMARY KEY,
	hash VARCHAR NOT NULL
);

-- Indexes for performance optimization
-- CREATE INDEX idx_conversation_participants_user_id ON conversation_participants(user_id);
-- CREATE INDEX idx_messages_conversation_id ON messages(conversation_id, sent_at DESC);
-- CREATE INDEX idx_message_status_user_id ON message_status(user_id);
-- CREATE INDEX idx_users_username ON users(username);
-- CREATE INDEX idx_users_email ON users(email);

